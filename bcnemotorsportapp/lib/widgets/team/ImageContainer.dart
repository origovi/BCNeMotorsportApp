import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final bool circular;
  final CachedNetworkImage image;
  final double size;
  final bool hasData;
  final void Function() onTap;
  final Widget placeholder;

  const ImageContainer(
      {this.circular = true,
      this.image,
      this.size = 50,
      this.onTap,
      this.placeholder = const Icon(Icons.person),
      this.hasData = true});

  @override
  Widget build(BuildContext context) {
    if (circular)
      return Material(
        // AJUSTAR BORDE, mirar el des-zoom que es fa al obrir foto
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        child: Container(
          height: size,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: InkWell(
                onTap: onTap,
                child: hasData ? image : placeholder,
              ),
            ),
          ),
        ),
      );
    else
      return Material(
        color: Colors.white,
        child: Container(
          height: size,
          child: InkWell(
            onTap: onTap,
            child: hasData ? image : placeholder,
          ),
        ),
      );
  }
}
