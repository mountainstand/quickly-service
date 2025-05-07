package com.vpn.quickly.app

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import io.flutter.embedding.android.FlutterActivity
import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val vpnPermissionChannel = "vpn_permission_channel"
    private val vpnPermissionRequestCode = 1001

    private val openVPNPermissionRequestCode = 24

    override fun onResume() {
        super.onResume()
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vpnPermissionChannel).setMethodCallHandler { call, result ->
            if (call.method == "requestVpnPermission") {
                requestVpnPermission(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun requestVpnPermission(result: MethodChannel.Result) {
        val intent = VpnService.prepare(this)
        if (intent != null) {
            startActivityForResult(intent, vpnPermissionRequestCode)
            result.success(false) // Permission requested
        } else {
            result.success(true) // Already granted
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == openVPNPermissionRequestCode && resultCode == RESULT_OK)
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == vpnPermissionRequestCode) {
            if (resultCode == Activity.RESULT_OK) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vpnPermissionChannel).invokeMethod("vpnPermissionResult", true)
            } else {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vpnPermissionChannel).invokeMethod("vpnPermissionResult", false)
            }
        }
    }
}
