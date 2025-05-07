//
//  PacketTunnelProvider.swift
//  OpenVPNNetworkExtensioniOS
//
//  Created by iapp on 28/02/25.
//

import NetworkExtension
import OpenVPNAdapter
import os.log

//MARK: - NEPacketTunnelFlow
extension NEPacketTunnelFlow: @retroactive OpenVPNAdapterPacketFlow {}

//MARK: - PacketTunnelProvider
class PacketTunnelProvider: NEPacketTunnelProvider {
    
    lazy var vpnAdapter: OpenVPNAdapter = {
        let adapter = OpenVPNAdapter()
        adapter.delegate = self
        return adapter
    }()
    
    let vpnReachability = OpenVPNReachability()
    var providerManager: NETunnelProviderManager!
    
    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?
    var groupIdentifier: String?
    
    static var connectionIndex = 0;
    static var timeOutEnabled = true;
    
    func loadProviderManager(completion:@escaping (_ error : Error?) -> Void)  {
        print(#function, "called")
        NETunnelProviderManager.loadAllFromPreferences { (managers, error)  in
            if error == nil {
                self.providerManager = managers?.first ?? NETunnelProviderManager()
                self.print(#function, "completion(nil)")
                completion(nil)
            } else {
                completion(error)
                self.print(#function, "completion(nil)")
            }
        }
    }
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        print(#function, "called")
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration
        else {
            fatalError()
        }
        guard let ovpnFileContent: Data = providerConfiguration["config"] as? Data else {
            fatalError()
        }
        
        guard let groupIdentifier: Data = providerConfiguration["groupIdentifier"] as? Data else{
            fatalError()
        }
        self.groupIdentifier = String(decoding: groupIdentifier, as: UTF8.self)
        
        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
        configuration.tunPersist = false
        
        // Apply OpenVPN configuration.
        let properties: OpenVPNConfigurationEvaluation
        do {
            properties = try vpnAdapter.apply(configuration: configuration)
            print(#function, "setting properties")
        } catch {
            completionHandler(error)
            print(#function, "completionHandler(error)")
            return
        }
        
        if !properties.autologin {
            print(#function, "in !properties.autologin")
            guard let username = options?["username"] as? String, let password = options?["password"] as? String else {
                fatalError()
            }
            let credentials = OpenVPNCredentials()
            credentials.username = username
            credentials.password = password
            do {
                print(#function, "in vpnAdapter.provide")
                try vpnAdapter.provide(credentials: credentials)
            } catch {
                print(#function, "in vpnAdapter.provide completionHandler(error)")
                completionHandler(error)
                return
            }
        }
        
        vpnReachability.startTracking { [weak self] status in
            self?.print(#function, "vpnReachability.startTracking 1")
            guard status == .reachableViaWiFi else { return }
            self?.print(#function, "vpnReachability.startTracking 2")
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
            self?.print(#function, "vpnReachability.startTracking 3")
        }
        startHandler = completionHandler
        print(#function, "vpnAdapter.connect")
        vpnAdapter.connect(using: packetFlow)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        print(#function, "called")
        stopHandler = completionHandler
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        vpnAdapter.disconnect()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        print(#function, "called")
        if String(data: messageData, encoding: .utf8) == "OPENVPN_STATS" {
            var toSave = ""
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            toSave += UserDefaults.init(suiteName: groupIdentifier)?.string(forKey: "connected_on") ?? ""
            toSave+="_"
            toSave += String(vpnAdapter.interfaceStatistics.packetsIn)
            toSave+="_"
            toSave += String(vpnAdapter.interfaceStatistics.packetsOut)
            toSave+="_"
            toSave += String(vpnAdapter.interfaceStatistics.bytesIn)
            toSave+="_"
            toSave += String(vpnAdapter.interfaceStatistics.bytesOut)
            UserDefaults.init(suiteName: groupIdentifier)?.setValue(toSave, forKey: "connectionUpdate")
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
    
    @objc func stopVPN() {
        print(#function, "called")
        loadProviderManager { (err :Error?) in
            if err == nil {
                self.providerManager.connection.stopVPNTunnel();
            }
        }
    }
}

//MARK: - OpenVPNAdapterDelegate
extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        print(#function, "called")
        networkSettings?.dnsSettings?.matchDomains = [""]
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
    }
    
    
    func _updateEvent(_ event: OpenVPNAdapterEvent, openVPNAdapter: OpenVPNAdapter) {
        print(#function, "called", event)
        var toSave = ""
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        switch event {
        case .connected:
            toSave = "CONNECTED"
            UserDefaults.init(suiteName: groupIdentifier)?.setValue(formatter.string(from: Date.now), forKey: "connected_on")
            break
        case .disconnected:
            toSave = "DISCONNECTED"
            break
        case .connecting:
            toSave = "CONNECTING"
            break
        case .reconnecting:
            toSave = "RECONNECTING"
            break
        case .info:
            toSave = "CONNECTED"
            break
        default:
            UserDefaults.init(suiteName: groupIdentifier)?.removeObject(forKey: "connected_on")
            toSave = "INVALID"
        }
        UserDefaults.init(suiteName: groupIdentifier)?.setValue(toSave, forKey: "vpnStage")
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        print(#function, "called")
        PacketTunnelProvider.timeOutEnabled = true;
        _updateEvent(event, openVPNAdapter: openVPNAdapter)
        switch event {
        case .connected:
            PacketTunnelProvider.timeOutEnabled = false;
            if reasserting {
                reasserting = false
            }
            guard let startHandler = startHandler else { return }
            startHandler(nil)
            self.startHandler = nil
            break
        case .disconnected:
            PacketTunnelProvider.timeOutEnabled = false;
            guard let stopHandler = stopHandler else { return }
            if vpnReachability.isTracking {
                vpnReachability.stopTracking()
            }
            stopHandler()
            self.stopHandler = nil
            break
        case .reconnecting:
            reasserting = true
            break
        default:
            break
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        print(#function, "called")
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal == true else {
            return
        }
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        print(#function, "called", logMessage)
    }
    
    func print(_ items: Any...) {
        let log = OSLog(subsystem: "com.vpn.quickly.app.OpenVPNNetworkExtensioniOS", category: "NetworkExtension")
        for item in items {
            os_log("OpenVPNNetworkExtensioniOS", log: log, "\(item)")
        }
    }
}
