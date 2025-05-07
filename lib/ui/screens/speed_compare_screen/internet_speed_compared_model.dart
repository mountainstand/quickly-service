import 'package:flutter/foundation.dart';

@immutable
class InternetSpeedComparedModel {
  final bool hasIncreased;
  final String speed;
  final String percentageDifference;

  const InternetSpeedComparedModel({
    required this.hasIncreased,
    required this.speed,
    required this.percentageDifference,
  });
}
