import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/services/StorageService.dart';
import 'package:bcnemotorsportapp/widgets/team/ImageContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String imageName;
  final bool circular;
  final double size;
  final bool displayable;
  final String displayTitle;
  final Widget imagePlaceholder;

  ShowImage(this.imageName,
      {this.circular=true,
      this.size=50,
      this.imagePlaceholder = const Icon(Icons.person),
      this.displayable = false,
      this.displayTitle}) {
    assert(!displayable || displayTitle != null,
        "If displayable is set to true, displayTitle must be set.");
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
          return Hero(
            tag: imageName,
            child: ImageContainer(
              circular: circular,
              size: size,
              image: CachedNetworkImage(
                imageUrl: snapshot.data,
                placeholder: (_, __) => imagePlaceholder,
                fit: BoxFit.cover,
              ),
              onTap: displayable
                  ? () => Navigator.of(context).pushNamed(
                        '/pageDisplayItem',
                        arguments: {
                          'child': InteractiveViewer(
                            minScale: 1,
                            maxScale: 100,
                            boundaryMargin: EdgeInsets.all(100),
                            panEnabled: false,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (_, __) => imagePlaceholder,
                              fit: BoxFit.cover,
                            ),
                          ),
                          'heroTag': imageName,
                          'title': displayTitle,
                        },
                      )
                  : null,
            ),
          );
        else
          return ImageContainer(hasData: false);
      },
    );
  }
}
