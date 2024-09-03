import 'package:flutter_quill/flutter_quill.dart';

class ImageBlockEmbed extends CustomBlockEmbed {
  const ImageBlockEmbed(String value) : super(imageType, value);

  static const String imageType = 'image';

  static ImageBlockEmbed fromUrl(String url) => ImageBlockEmbed(url);

  String get url => data;
}
