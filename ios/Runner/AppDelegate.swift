import Flutter
import UIKit
import GoogleMobileAds

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "cdcdfef3bc41404b7e86304a1653c415", "0448db96c54c2d30005a05154f252eda" ]
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
