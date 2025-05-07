import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants_and_extensions/assets.dart';

/// Initialised in [MyApp]
class LoaderController extends GetxController {
  LoaderController._sharedInstance() : super();
  static final LoaderController _shared = LoaderController._sharedInstance();
  factory LoaderController() => _shared;

  final _showLoader = false.obs;
  final _hideLoaderAnimationInProgress = false.obs;

  bool get shouldShowLoader => _showLoader.value;
  bool get hideLoaderAnimationInProgress =>
      _hideLoaderAnimationInProgress.value;

  OverlayEntry? _overlayEntry;

  void showLoader() {
    // _showLoader.value = true;

    if (_overlayEntry != null) return; // Already showing
    final size = Get.width * 0.8;
    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Image.asset(
                  Assets().gifAssets.loader,
                  width: size,
                  height: size,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final context = Get.overlayContext;
    if (context != null) {
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    }
  }

  void hideLoader() {
    // if (_showLoader.value) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    // setHideLoaderAnimationInProgress(to: true);
    // _showLoader.value = false;
    // }
  }

  void setHideLoaderAnimationInProgress({required bool to}) {
    _hideLoaderAnimationInProgress.value = to;
  }
}
