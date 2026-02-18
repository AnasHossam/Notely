import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'package:notely/features/note/domain/note_entity.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PdfService {
  Future<void> generateAndSharePdf(NoteEntity note) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.spaceGroteskRegular();
    final fontBold = await PdfGoogleFonts.spaceGroteskBold();
    final fontItalic = await PdfGoogleFonts.spaceGroteskMedium();
    List<dynamic> jsonContent = [];
    try {
      jsonContent = jsonDecode(note.content);
    } catch (e) {
      jsonContent = [
        {'insert': '${note.content}\n'}
      ];
    }

    final doc = quill.Document.fromJson(jsonContent);
    final delta = doc.toDelta();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(note, font, fontBold),
            pw.SizedBox(height: 16),
            pw.Text(
              note.title,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 24,
                color: PdfColor.fromHex('#191022'),
              ),
            ),
            pw.SizedBox(height: 16),
            ..._buildContent(delta, font, fontBold, fontItalic),
          ];
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: '${note.title.replaceAll(' ', '_')}.pdf');
  }

  pw.Widget _buildHeader(NoteEntity note, pw.Font font, pw.Font fontBold) {
    final dateStr = DateFormat('MMMM d, yyyy . h:mm a').format(note.updatedAt);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          dateStr,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            color: PdfColor.fromHex('#8B5CF6'),
          ),
        ),
        if (note.tag != null && note.tag!.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#8B5CF6'),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
            ),
            child: pw.Text(
              note.tag!,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 10,
                color: PdfColors.white,
              ),
            ),
          ),
      ],
    );
  }

  List<pw.Widget> _buildContent(
    dynamic delta,
    pw.Font font,
    pw.Font fontBold,
    pw.Font fontItalic,
  ) {
    final widgets = <pw.Widget>[];

    final ops = (delta as dynamic).toList();

    List<pw.InlineSpan> currentLineSpans = [];

    for (final op in ops) {
      if (op.data is String) {
        final text = op.data as String;

        if (text == '\n') {
          _finalizeLine(
              widgets, currentLineSpans, op.attributes, font, fontBold);
          currentLineSpans = [];
          continue;
        }

        final parts = text.split('\n');
        for (int i = 0; i < parts.length; i++) {
          final part = parts[i];
          if (part.isNotEmpty) {
            currentLineSpans.add(
                _buildSpan(part, op.attributes, font, fontBold, fontItalic));
          }

          if (i < parts.length - 1) {
            _finalizeLine(
                widgets, currentLineSpans, op.attributes, font, fontBold);
            currentLineSpans = [];
          }
        }
      } else if (op.data is Map && (op.data as Map).containsKey('image')) {
        if (currentLineSpans.isNotEmpty) {
          _finalizeLine(widgets, currentLineSpans, null, font, fontBold);
          currentLineSpans = [];
        }

        final imageWidget = _buildImage(op.data['image']);
        if (imageWidget != null) {
          widgets.add(pw.SizedBox(height: 10));
          widgets.add(imageWidget);
          widgets.add(pw.SizedBox(height: 10));
        }
      }
    }

    if (currentLineSpans.isNotEmpty) {
      _finalizeLine(widgets, currentLineSpans, null, font, fontBold);
    }

    return widgets;
  }

  void _finalizeLine(
    List<pw.Widget> widgets,
    List<pw.InlineSpan> spans,
    Map<String, dynamic>? attributes,
    pw.Font font,
    pw.Font fontBold,
  ) {
    if (spans.isEmpty) {
      widgets.add(pw.SizedBox(height: 10));
      return;
    }

    pw.TextAlign align = pw.TextAlign.left;
    double fontSize = 12;
    double spacing = 5;
    pw.Font? customFont;

    if (attributes != null) {
      if (attributes['align'] == 'center') align = pw.TextAlign.center;
      if (attributes['align'] == 'right') align = pw.TextAlign.right;
      if (attributes['align'] == 'justify') align = pw.TextAlign.justify;

      if (attributes['header'] != null) {
        final level = attributes['header'];
        if (level == 1) {
          fontSize = 24;
          customFont = fontBold;
          spacing = 15;
        } else if (level == 2) {
          fontSize = 18;
          customFont = fontBold;
          spacing = 10;
        } else if (level == 3) {
          fontSize = 14;
          customFont = fontBold;
          spacing = 8;
        }
      }

      if (attributes['list'] != null) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(font: font, fontSize: 12)),
                pw.Expanded(
                  child: pw.RichText(
                    text: pw.TextSpan(children: spans),
                    textAlign: align,
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }
    }

    if (customFont != null || fontSize != 12) {
      for (int i = 0; i < spans.length; i++) {
        final span = spans[i];
        if (span is pw.TextSpan) {
          spans[i] = pw.TextSpan(
              text: span.text,
              style:
                  span.style!.copyWith(fontSize: fontSize, font: customFont));
        }
      }
    }

    widgets.add(
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: spacing),
        child: pw.RichText(
          text: pw.TextSpan(children: spans),
          textAlign: align,
        ),
      ),
    );
  }

  pw.InlineSpan _buildSpan(
    String text,
    Map<String, dynamic>? attributes,
    pw.Font font,
    pw.Font fontBold,
    pw.Font fontItalic,
  ) {
    pw.Font spanFont = font;
    double fontSize = 12;
    PdfColor color = PdfColor.fromHex('#6B7280');
    PdfColor? background;
    pw.TextDecoration decoration = pw.TextDecoration.none;

    if (attributes != null) {
      final isBold = attributes['bold'] == true;
      final isItalic = attributes['italic'] == true;
      final isUnderline = attributes['underline'] == true;
      final isStrike = attributes['strike'] == true;

      if (isBold && isItalic) {
        spanFont = fontBold;
      } else if (isBold) {
        spanFont = fontBold;
      } else if (isItalic) {
        spanFont = fontItalic;
      }

      if (isUnderline && isStrike) {
        decoration = pw.TextDecoration.combine(
            [pw.TextDecoration.underline, pw.TextDecoration.lineThrough]);
      } else if (isUnderline) {
        decoration = pw.TextDecoration.underline;
      } else if (isStrike) {
        decoration = pw.TextDecoration.lineThrough;
      }

      if (attributes['color'] != null) {
        color = PdfColor.fromHex(attributes['color']);
      }

      if (attributes['background'] != null) {
        background = PdfColor.fromHex(attributes['background']);
      }

      if (attributes['size'] == 'small') fontSize = 10;
      if (attributes['size'] == 'large') fontSize = 16;
      if (attributes['size'] == 'huge') fontSize = 20;
    }

    return pw.TextSpan(
      text: text,
      style: pw.TextStyle(
        font: spanFont,
        fontSize: fontSize,
        color: color,
        background:
            background != null ? pw.BoxDecoration(color: background) : null,
        decoration: decoration,
      ),
    );
  }

  pw.Widget? _buildImage(dynamic imageSource) {
    final path = imageSource.toString();
    if (!path.startsWith('http')) {
      try {
        final imageFile = File(path);
        if (imageFile.existsSync()) {
          final image = pw.MemoryImage(imageFile.readAsBytesSync());
          return pw.Center(
            child: pw.Container(
              width: double.infinity,
              child: pw.ClipRRect(
                horizontalRadius: 12,
                verticalRadius: 12,
                child: pw.Image(image, fit: pw.BoxFit.fitWidth),
              ),
            ),
          );
        }
      } catch (e) {
        // ignore
      }
    }
    return null;
  }
}
