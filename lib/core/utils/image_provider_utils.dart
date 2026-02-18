import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageProviderUtils {
  static ImageProvider? getImageProvider(String? path) {
    if (path == null || path.isEmpty) return null;

    if (kIsWeb ||
        path.startsWith('http') ||
        path.startsWith('https') ||
        path.startsWith('blob:')) {
      return NetworkImage(path);
    }

    return FileImage(io.File(path));
  }

  static Widget imageFromPath(
    String path, {
    BoxFit? fit,
    double? width,
    double? height,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    if (kIsWeb ||
        path.startsWith('http') ||
        path.startsWith('https') ||
        path.startsWith('blob:')) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder,
      );
    }

    return Image.file(
      io.File(path),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }
}
