import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants_and_extensions/nonui_extensions.dart';

class AssetImageWidget extends StatelessWidget {
  final String assetName;
  final BoxFit fit;
  final Color? color;
  final double? width;
  final double? height;

  const AssetImageWidget({
    super.key,
    required this.assetName,
    this.fit = BoxFit.contain,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final getExtension = assetName.getFileExtension;
    return getExtension == "svg"
        ? SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(
                    color!,
                    BlendMode.srcIn,
                  )
                : null,
          )
        : Image.asset(
            assetName,
            width: width,
            height: height,
            fit: BoxFit.fitWidth,
            color: color,
            colorBlendMode: color != null ? BlendMode.srcIn : null,
          );
  }
}
