import 'package:flutter_quill/flutter_quill.dart';

class ImageBlockEmbed extends CustomBlockEmbed {
  // bool isFullSize;

  ImageBlockEmbed(
    String value,
  ) : super(imageType, value);

  static const String imageType = 'image';

  static ImageBlockEmbed fromUrl(String url, {bool isFullSize = false}) =>
      ImageBlockEmbed(
        url,
      );

  // toggleIsFullSize() {
  //   isFullSize = !isFullSize;
  // }

  String get url => data;
}
