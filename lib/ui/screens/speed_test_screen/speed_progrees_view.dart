import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../constants_and_extensions/assets.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';

class SpeedProgreesView extends StatefulWidget {
  final double meterMaxSpeed;
  final double meterMaxSpeedToShow;
  final double speed;
  final double speedToShow;

  const SpeedProgreesView({
    super.key,
    this.meterMaxSpeed = 120,
    this.meterMaxSpeedToShow = 100,
    required this.speed,
  }) : speedToShow = speed > meterMaxSpeedToShow ? meterMaxSpeedToShow : speed;

  @override
  State<SpeedProgreesView> createState() => _SpeedProgreesViewState();
}

class _SpeedProgreesViewState extends State<SpeedProgreesView>
    with TickerProviderStateMixin {
  late AnimationController _meterAC;
  late Animation<double> _meterRotationAnimation;
  late Animation<double> _circularProgressAnimation;
  double percentageValue = 0;

  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    _meterAC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..addListener(() {
        setState(() {});
      });

    final maxValue = getMaxValue(widget.speedToShow);
    percentageValue = (widget.speedToShow / maxValue);

    setUpAnimations(startValue: 0, endValue: percentageValue);
    super.initState();
  }

  @override
  void dispose() {
    _meterAC.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SpeedProgreesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      final maxValue = getMaxValue(widget.speedToShow);
      percentageValue = (widget.speedToShow / maxValue);

      final oldMaxValue = getMaxValue(oldWidget.speedToShow);
      final oldPercentageValue = (oldWidget.speedToShow / oldMaxValue);
      setUpAnimations(
        startValue: oldPercentageValue,
        endValue: percentageValue,
      );
    }
  }

  int getMaxValue(double value) {
    // final parts = value.toString().split('.');

    // // Get the length of the integer part
    // final length = parts[0].length;

    // return math.pow(10, length).toInt();
    return widget.meterMaxSpeed.toInt();
  }

  void setUpAnimations({required double startValue, required double endValue}) {
    _meterRotationAnimation = Tween<double>(
      begin: startValue * 2 * math.pi,
      end: endValue * 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _meterAC,
        curve: Curves.easeInOut,
      ),
    );

    _circularProgressAnimation = Tween<double>(
      begin: startValue,
      end: endValue,
    ).animate(
      CurvedAnimation(
        parent: _meterAC,
        curve: Curves.easeInOut,
      ),
    );

    _meterAC.reset();
    _meterAC.forward();
  }

  @override
  Widget build(BuildContext context) {
    final outerContainerSize = Get.width * 0.71;
    final size = Get.width * 0.6;
    double meterSize = size * 0.23;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: outerContainerSize,
            height: outerContainerSize,
            decoration: BoxDecoration(
              color: _themeController.screenBG,
              shape: BoxShape.circle,
              border: Border.all(
                width: 5,
                color: _themeController.backgroundColor3,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: _themeController.shadowColor,
                )
              ],
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: meterSize,
                      spreadRadius: meterSize / 1.25,
                      color: _themeController.shadowColor2,
                    )
                  ],
                ),
                width: meterSize / 1.25,
                height: meterSize / 1.25,
              ),
            ),
          ),
          CustomPaint(
              size: Size(size, size),
              painter: GradientCircularProgressPainter(
                strokeWidth: 15,
                value: 1,
                backgroundColor: _themeController.backgroundColor5,
              )),
          AnimatedBuilder(
              animation: _meterAC,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(size, size),
                  painter: GradientCircularProgressPainter(
                    value: _circularProgressAnimation.value,
                    strokeWidth: 15,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        _themeController.orange,
                        _themeController.yellow,
                      ],
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: outerContainerSize / 5.5,
            child: Column(
              children: [
                Text(
                  widget.speedToShow.toString(),
                  style: _themeController.title3BoldTextColor2TS,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: AssetImageWidget(
                        assetName: Assets().imageAssets.internetSpeedIcon,
                        width: 20,
                        height: 20,
                        color: _themeController.iconColor2,
                      ),
                    ),
                    Text(
                      "Mbps",
                      style: _themeController.captionMediumTextColor2TS,
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: outerContainerSize / 2,
            child: AnimatedBuilder(
              animation: _meterAC,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _meterRotationAnimation.value,
                  origin: Offset(0, -meterSize),
                  alignment: Alignment.bottomCenter,
                  child: CustomPaint(
                    size: Size(meterSize / 3,
                        meterSize), // Match the SVG viewBox dimensions
                    painter: CustomShapePainter(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color? backgroundColor;
  final Gradient? gradient;

  GradientCircularProgressPainter({
    required this.value,
    this.strokeWidth = 10.0,
    this.backgroundColor,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    // Create a gradient shader

    // Define a stroke paint
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (gradient != null) {
      final gradientShader = gradient?.createShader(rect);
      paint.shader = gradientShader;
    }

    if (backgroundColor != null) {
      paint.color = backgroundColor!;
    }

    // Draw the arc
    final startAngle = 90.0 * (3.14159265359 / 180.0); // Start from the top
    final sweepAngle = 360.0 * value * (3.14159265359 / 180.0);

    canvas.drawArc(rect.deflate(5.0), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomShapePainter extends CustomPainter {
  final ThemeController _themeController = Get.find();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(1, -1); // Flip vertically
    canvas.translate(0, -size.height); // Adjust position after flipping

    final paint = Paint();

    // Draw the circle
    paint.color = _themeController.primaryColor;
    final circleRadius = size.width / 3.7;
    canvas.drawCircle(Offset(size.width / 2, size.height), circleRadius, paint);

    final path = Path();

    final archStartPoint = size.width / 6;
    path.moveTo(archStartPoint, size.height);
    path.lineTo(0, size.height);

    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - archStartPoint, size.height);

    path.arcToPoint(
      Offset(archStartPoint, size.height),
      radius: Radius.circular(archStartPoint),
      clockwise: false,
    );

    path.close();

    paint.color = paint.color = _themeController.backgroundColor4;
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
