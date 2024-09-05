import 'package:flutter_quill/flutter_quill.dart';

class ImageBlockEmbed extends CustomBlockEmbed {
  final bool isFullSize;

  const ImageBlockEmbed(String value, {this.isFullSize = true})
      : super(imageType, value);

  static const String imageType = 'image';

  static ImageBlockEmbed fromUrl(String url, {bool isFullSize = true}) =>
      ImageBlockEmbed(url, isFullSize: isFullSize);

  String get url => data;
}
