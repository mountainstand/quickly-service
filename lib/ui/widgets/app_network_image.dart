import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageURL;
  final BoxFit fit;
  final Widget? placeholder;

  const AppNetworkImage({
    super.key,
    required this.imageURL,
    this.fit = BoxFit.fill,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: fit,
      placeholder: (context, url) => placeholder ?? CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
