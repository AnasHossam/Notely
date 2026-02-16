import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final String imageUrl = embedContext.node.value.data;
    Widget imageWidget;

    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(imageUrl);
    } else {
      imageWidget = Image.file(File(imageUrl));
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageWidget,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
