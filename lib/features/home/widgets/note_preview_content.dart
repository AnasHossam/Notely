import 'dart:convert';
import 'package:notely/core/utils/image_provider_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NotePreviewContent extends StatelessWidget {
  final String contentJson;
  final int maxLines;
  final TextStyle? style;
  final String? highlightTerm;

  const NotePreviewContent({
    super.key,
    required this.contentJson,
    this.maxLines = 5,
    this.style,
    this.highlightTerm,
  });

  @override
  Widget build(BuildContext context) {
    if (contentJson.isEmpty) return const SizedBox.shrink();

    try {
      final List<dynamic> json = jsonDecode(contentJson);
      final doc = quill.Document.fromJson(json);
      final delta = doc.toDelta();

      final spans = <InlineSpan>[];
      final allLines = <List<InlineSpan>>[];
      var currentLine = <InlineSpan>[];

      final imageLineIndices = <int>{};
      final matchLineIndices = <int>{};
      int currentLineIndex = 0;

      for (final op in delta.toList()) {
        if (op.data is String) {
          String text = op.data as String;

          while (text.contains('\n')) {
            final index = text.indexOf('\n');
            final part = text.substring(0, index);
            final remainder = text.substring(index + 1);

            if (part.isNotEmpty) {
              if (highlightTerm != null &&
                  highlightTerm!.isNotEmpty &&
                  part.toLowerCase().contains(highlightTerm!.toLowerCase())) {
                matchLineIndices.add(currentLineIndex);
              }
              currentLine.add(
                  _createSpan(part, op.attributes, context, highlightTerm));
            }

            Widget? prefixWidget;
            if (op.attributes != null && op.attributes!.containsKey('list')) {
              final listType = op.attributes!['list'];
              if (listType == 'bullet') {
                prefixWidget = _buildDot(context);
              } else if (listType == 'checked') {
                prefixWidget = _buildCheckbox(context, true);
              } else if (listType == 'unchecked') {
                prefixWidget = _buildCheckbox(context, false);
              }
            }

            if (prefixWidget != null) {
              currentLine.insert(
                  0,
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: prefixWidget));
            }

            allLines.add(List.from(currentLine));
            currentLine = [];
            currentLineIndex++;

            text = remainder;
          }

          if (text.isNotEmpty) {
            if (highlightTerm != null &&
                highlightTerm!.isNotEmpty &&
                text.toLowerCase().contains(highlightTerm!.toLowerCase())) {
              matchLineIndices.add(currentLineIndex);
            }
            currentLine
                .add(_createSpan(text, op.attributes, context, highlightTerm));
          }
        } else if (op.data is Map) {
          imageLineIndices.add(currentLineIndex);
          currentLine.add(_createImageSpan(op.data as Map));
        }
      }

      if (currentLine.isNotEmpty) {
        allLines.add(currentLine);
      }

      final visibleLines = <List<InlineSpan>>[];

      if (highlightTerm == null ||
          highlightTerm!.isEmpty ||
          matchLineIndices.isEmpty) {
        for (var line in allLines) {
          visibleLines.add(line);
          visibleLines.add([const TextSpan(text: '\n')]);
        }
      } else {
        final linesToShow = <int>{};

        if (imageLineIndices.isNotEmpty) {
          linesToShow.add(imageLineIndices.first);
        }

        if (matchLineIndices.isNotEmpty) {
          linesToShow.add(matchLineIndices.first);
        }

        final sortedIndices = linesToShow.toList()..sort();

        int lastIdx = -1;
        for (final idx in sortedIndices) {
          if (idx >= allLines.length) continue;

          if (lastIdx != -1 && idx > lastIdx + 1) {
            visibleLines.add([
              TextSpan(
                  text: '\n...\n', style: style?.copyWith(color: Colors.grey))
            ]);
          } else if (lastIdx != -1) {
            visibleLines.add([const TextSpan(text: '\n')]);
          }

          visibleLines.add(allLines[idx]);
          lastIdx = idx;
        }
      }

      for (final line in visibleLines) {
        spans.addAll(line);
      }

      if (spans.isEmpty) return const SizedBox.shrink();

      return RichText(
        text: TextSpan(children: spans),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    } catch (e) {
      return Text('Error loading preview',
          style: style?.copyWith(color: Colors.red));
    }
  }

  InlineSpan _createSpan(String text, Map<String, dynamic>? attributes,
      BuildContext context, String? highlightTerm) {
    TextStyle effectiveStyle =
        _getStyle(attributes, style) ?? const TextStyle();

    if (highlightTerm != null &&
        highlightTerm.isNotEmpty &&
        text.toLowerCase().contains(highlightTerm.toLowerCase())) {
      return _buildHighlightedSpan(
          context, text, effectiveStyle, highlightTerm);
    }
    return TextSpan(text: text, style: effectiveStyle);
  }

  TextSpan _buildHighlightedSpan(
      BuildContext context, String text, TextStyle style, String term) {
    final lowerText = text.toLowerCase();
    final lowerTerm = term.toLowerCase();

    final children = <InlineSpan>[];
    int currentIndex = 0;

    while (true) {
      final matchIndex = lowerText.indexOf(lowerTerm, currentIndex);
      if (matchIndex == -1) {
        if (currentIndex < text.length) {
          children
              .add(TextSpan(text: text.substring(currentIndex), style: style));
        }
        break;
      }

      if (matchIndex > currentIndex) {
        children.add(TextSpan(
            text: text.substring(currentIndex, matchIndex), style: style));
      }

      final matchText = text.substring(matchIndex, matchIndex + term.length);
      children.add(TextSpan(
          text: matchText,
          style: style.copyWith(
            backgroundColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.3),
            color: Theme.of(context).primaryColor,
          )));

      currentIndex = matchIndex + term.length;
    }

    return TextSpan(children: children);
  }

  Widget _buildDot(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 4),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, bool checked) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 2),
      child: Icon(
        checked ? Icons.check_box : Icons.check_box_outline_blank,
        size: 14,
        color: checked ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  InlineSpan _createImageSpan(Map<dynamic, dynamic> data) {
    if (data.containsKey('image')) {
      final imageSource = data['image'].toString();
      Widget? imageWidget;

      if (imageSource.startsWith('http')) {
        imageWidget = Image.network(imageSource, fit: BoxFit.cover);
      } else {
        try {
          imageWidget = ImageProviderUtils.imageFromPath(
            imageSource,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
          );
        } catch (e) {
          imageWidget = const Icon(Icons.image_not_supported);
        }
      }

      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: imageWidget,
            ),
          ),
        ),
      );
    }
    return const TextSpan(text: '');
  }

  TextStyle? _getStyle(Map<String, dynamic>? attributes, TextStyle? baseStyle) {
    if (attributes == null) return baseStyle;

    TextStyle newStyle = baseStyle ?? const TextStyle();

    if (attributes['bold'] == true) {
      newStyle = newStyle.copyWith(fontWeight: FontWeight.bold);
    }
    if (attributes['italic'] == true) {
      newStyle = newStyle.copyWith(fontStyle: FontStyle.italic);
    }

    if (attributes['color'] != null) {
      newStyle = newStyle.copyWith(color: _hexToColor(attributes['color']));
    }
    if (attributes['background'] != null) {
      newStyle = newStyle.copyWith(
          backgroundColor: _hexToColor(attributes['background']));
    }

    return newStyle;
  }

  Color? _hexToColor(String? hexString) {
    if (hexString == null) return null;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }
}
