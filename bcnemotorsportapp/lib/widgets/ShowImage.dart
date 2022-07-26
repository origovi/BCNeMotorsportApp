import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/services/StorageService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String imageName;
  final bool circular;
  final double size;
  final bool displayable;
  final String displayTitle;
  final Widget imagePlaceholder;
  final List<Widget> displayActions;
  final void Function() onTap;

  ShowImage(
    this.imageName, {
    this.circular = true,
    this.size = 50,
    imagePlaceholder = const Icon(Icons.person),
    this.displayable = false,
    this.displayTitle,
    this.onTap,
    this.displayActions,
  }) : this.imagePlaceholder = Container(
          height: size,
          width: size,
          child: Center(child: imagePlaceholder),
        ) {
    assert(!displayable || displayTitle != null,
        "If displayable is set to true, displayTitle must be set.");
    assert(displayActions == null || displayable, "displayActions cannot be set if !displayable.");
    assert(onTap == null || !displayable);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageService.getImageUrl(imageName),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          Popup.errorPopup(context, snapshot.error.toString());
          return imagePlaceholder;
        } else if (snapshot.hasData)
          return CachedNetworkImage(
            imageUrl: snapshot.data,
            placeholder: (_, __) => imagePlaceholder,
            errorWidget: (_, __, ___) => imagePlaceholder,
            imageBuilder: (context, image) {
              return GestureDetector(
                onTap: displayable
                    ? () => Navigator.of(context).pushNamed(
                          '/pageDisplayItem',
                          arguments: {
                            'child': Column(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data,
                                    placeholder: (_, __) => imagePlaceholder,
                                    fit: BoxFit.contain,
                                    imageBuilder: (context, image) {
                                      return InteractiveViewer(
                                        minScale: 1,
                                        maxScale: 50,
                                        child: Image(image: image),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            'heroTag': 'profile_' + imageName,
                            'title': displayTitle,
                            'actions': displayActions,
                          },
                        )
                    : onTap,
                child: Hero(
                  tag: 'profile_' + imageName,
                  child: Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      shape: this.circular ? BoxShape.circle : null,
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                    ),
                  ),
                ),
              );
            },
            fit: BoxFit.cover,
          );
        else
          return GestureDetector(
            onTap: displayable
                ? () => Navigator.of(context).pushNamed(
                      '/pageDisplayItem',
                      arguments: {
                        'child': Column(
                          children: [
                            Expanded(
                              child: InteractiveViewer(
                                minScale: 1,
                                maxScale: 1,
                                child: Image.asset("assets/profile_pic_placeholder.png"),
                              ),
                            ),
                          ],
                        ),
                        'heroTag': 'profile_' + imageName,
                        'title': displayTitle,
                        'actions': displayActions,
                      },
                    )
                : onTap,
            child: Hero(
              tag: 'profile_' + imageName,
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: this.circular ? BoxShape.circle : null,
                  image: DecorationImage(
                      image: AssetImage("assets/profile_pic_placeholder.png"), fit: BoxFit.cover),
                ),
              ),
            ),
          );
      },
    );
  }
}
