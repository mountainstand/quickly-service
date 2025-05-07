import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';

class AnimatedVPNButton extends StatefulWidget {
  final int animationDuration;
  final bool isVPNConnected;
  final VoidCallback toggleConnection;

  final ThemeMode themeMode;

  const AnimatedVPNButton({
    super.key,
    required this.animationDuration,
    required this.isVPNConnected,
    required this.themeMode,
    required this.toggleConnection,
  });

  @override
  State<AnimatedVPNButton> createState() => _AnimatedVPNButtonState();
}

class _AnimatedVPNButtonState extends State<AnimatedVPNButton>
    with TickerProviderStateMixin {
  final ThemeController _themeController = Get.find();

  late AnimationController _powerButtonAC;

  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<Color?> _iconColorAnimation;

  final List<AnimationController> _rippleACs = [];
  final rippleEffectAnimation = 3000;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();

    _powerButtonAC = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    );

    for (int i = 0; i < 2; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: rippleEffectAnimation), // Duration of one ripple
      );

      _rippleACs.add(controller);
    }

    _initializeAnimations();
    if (widget.isVPNConnected) {
      _startStopAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedVPNButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeMode != widget.themeMode) {
      _initializeAnimations();
    }
    if (oldWidget.isVPNConnected != widget.isVPNConnected) {
      _startStopAnimation();
    }
  }

  @override
  void dispose() {
    _powerButtonAC.dispose();
    _cancelRippleAnimation();
    _disposeRippleAnimation();
    super.dispose();
  }

  void _initializeAnimations() {
    _borderColorAnimation = ColorTween(
      begin: _themeController.borderColor,
      end: _themeController.activeBorderColor,
    ).animate(_powerButtonAC);

    _buttonColorAnimation = ColorTween(
      begin: _themeController.backgroundColor,
      end: _themeController.buttonSelectedColor2,
    ).animate(_powerButtonAC);

    _iconColorAnimation = ColorTween(
      begin: _themeController.iconColor,
      end: _themeController.buttonSelectedColor,
    ).animate(_powerButtonAC);
  }

  void _startStopAnimation() {
    if (widget.isVPNConnected) {
      _isCancelled = false;
      _powerButtonAC.forward();
      _rippleACs.asMap().forEach((index, rippleAC) {
        Future.delayed(
          Duration(
            milliseconds: index * (rippleEffectAnimation / 2).toInt(),
          ),
          () {
            if (!_isCancelled) {
              ('Animation Called in delay!', rippleAC.hashCode).log();
              rippleAC.repeat();
            }
          },
        );
      });
    } else {
      _powerButtonAC.reverse();
      _cancelRippleAnimation();
      for (final rippleAC in _rippleACs) {
        rippleAC.stop();
      }
    }
  }

  void _resetRippleAnimation() {
    for (final rippleAC in _rippleACs) {
      rippleAC.reset();
    }
  }

  void _disposeRippleAnimation() {
    for (final rippleAC in _rippleACs) {
      rippleAC.dispose();
    }
  }

  void _cancelRippleAnimation() {
    _isCancelled = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = Get.width * 0.45;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
            opacity: widget.isVPNConnected ? 1 : 0,
            duration: Duration(milliseconds: widget.animationDuration),
            onEnd: () {
              if (!widget.isVPNConnected) {
                _resetRippleAnimation();
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 2),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 8,
                      color:
                          _themeController.primaryColor.withValues(alpha: 0.35),
                    )
                  ]),
              child: Stack(
                children: [
                  for (final rippleAC in _rippleACs)
                    _buildRipple(
                      size: size,
                      rippleAC: rippleAC,
                      delay: 0.2,
                    ),
                ],
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _powerButtonAC,
            builder: (context, child) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: _borderColorAnimation.value!,
                  ),
                  borderRadius: BorderRadius.circular(size / 2),
                  color: _buttonColorAnimation.value,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: widget.toggleConnection,
                  child: Center(
                    child: AssetImageWidget(
                      assetName: Assets().imageAssets.powerIcon,
                      width: Get.width * 0.12,
                      height: Get.width * 0.12,
                      color: _iconColorAnimation.value!,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to create a ripple animation with a delay
  Widget _buildRipple({
    required double size,
    required AnimationController rippleAC,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: rippleAC,
      builder: (context, child) {
        final progress = (rippleAC.value).clamp(0.0, 1.0);
        final scale = Tween<double>(begin: 1, end: 2.2).transform(progress);
        final opacity = Tween<double>(begin: 1.0, end: 0).transform(progress);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 1.5),
                  border: Border.all(
                    width: 2,
                    color: _themeController.activeBorderColor,
                  )),
            ),
          ),
        );
      },
    );
  }
}
