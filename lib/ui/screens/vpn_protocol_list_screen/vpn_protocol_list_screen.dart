import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../global_controllers/theme_controller.dart';
import '../connect_vpn_screen/connect_vpn_controller.dart';

class VPNProtocolListScreen extends StatelessWidget {
  VPNProtocolListScreen({super.key});

  final ConnectVpnController _vpnController = Get.find();
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.selectProtocol,
            style: _themeController.headlineBoldTS,
          ),
        ),
        body: ListView.builder(
          itemCount: _vpnController.vpnProtocols.length,
          itemBuilder: (context, index) => _vpnProtocolItem(
            context: context,
            index: index,
          ),
        ),
      );
    });
  }

  Widget _vpnProtocolItem({
    required BuildContext context,
    required int index,
  }) {
    final protocol = _vpnController.vpnProtocols[index];
    void onPressed(newValue) {
      _vpnController.updateSelectedProtocol(newValue: newValue);
      Get.back();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: () => onPressed(protocol),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: _themeController.backgroundColor3,
            boxShadow: [
              BoxShadow(
                color: _themeController.shadowColor,
                spreadRadius: 2,
                blurRadius: 6,
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                protocol.title(context: context),
                style: _themeController.bodyBoldTS,
              ),
              Spacer(),
              Radio(
                value: protocol,
                groupValue: _vpnController.selectedVPNProtocol,
                onChanged: (newValue) => onPressed(newValue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
