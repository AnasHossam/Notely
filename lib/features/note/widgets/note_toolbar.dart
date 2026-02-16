import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notely/core/theme/app_colors.dart';

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({super.key, required this.controller});

  final QuillController controller;

  @override
  State<NoteToolbar> createState() => _NoteToolbarState();
}

class _NoteToolbarState extends State<NoteToolbar> {
  bool _isColorPaletteVisible = false;
  bool _isBackgroundMode = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final index = widget.controller.selection.baseOffset;
      final length = widget.controller.selection.extentOffset - index;

      // Insert newline, image, then newline to ensure proper spacing
      widget.controller.replaceText(index, length, '\n', null);
      widget.controller
          .replaceText(index + 1, 0, BlockEmbed.image(image.path), null);
      widget.controller.replaceText(index + 2, 0, '\n', null);

      // Move cursor after the inserted content
      widget.controller.updateSelection(
          TextSelection.collapsed(offset: index + 3), ChangeSource.local);
    }
  }

  void _toggleColorPalette(bool isBackground) {
    setState(() {
      if (_isColorPaletteVisible && _isBackgroundMode == isBackground) {
        _isColorPaletteVisible = false;
      } else {
        _isColorPaletteVisible = true;
        _isBackgroundMode = isBackground;
      }
    });
  }

  void _applyColor(Color color) {
    final hex = '#${color.value.toRadixString(16).substring(2)}';
    if (_isBackgroundMode) {
      widget.controller.formatSelection(BackgroundAttribute(hex));
    } else {
      widget.controller.formatSelection(ColorAttribute(hex));
    }
    setState(() {
      _isColorPaletteVisible = false;
    });
  }

  Widget _buildColorPalette() {
    if (!_isColorPaletteVisible) return const SizedBox.shrink();

    final colors = [
      AppColors.textPrimaryLightColor,
      AppColors.textPrimaryDarkColor,
      AppColors.textSecondaryLightColor,
      AppColors.textSecondaryDarkColor,
      AppColors.primaryLightColor,
      AppColors.primaryDarkColor,
      Colors.yellow,
      Colors.red,
      Colors.green,
    ];

    return Container(
      width: double.infinity,
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: colors.map((color) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: InkWell(
                onTap: () => _applyColor(color),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColorPalette(),
        if (_isColorPaletteVisible)
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
        QuillSimpleToolbar(
          controller: widget.controller,
          config: QuillSimpleToolbarConfig(
            showFontFamily: false,
            showFontSize: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
            showInlineCode: false,
            showLink: false,
            showQuote: false,
            showCodeBlock: false,
            showDividers: true,
            showHeaderStyle: false,
            showListNumbers: false,
            showListBullets: true,
            showListCheck: true,
            showIndent: false,
            showClearFormat: false,
            showRedo: false,
            showUndo: false,
            showClipboardCut: false,
            showClipboardCopy: false,
            showClipboardPaste: false,

            // Enabled buttons
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showStrikeThrough: false,
            showColorButton: true,
            showBackgroundColorButton: true,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: false,
            showDirection: false,

            customButtons: [
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.image),
                onPressed: () => _pickImage(),
              ),
            ],

            buttonOptions: QuillSimpleToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                iconTheme: QuillIconTheme(
                  iconButtonUnselectedData: const IconButtonData(
                    color: AppColors.textPrimaryLightColor,
                  ),
                  iconButtonSelectedData: IconButtonData(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.deepPurple),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                  ),
                ),
              ),
              color: QuillToolbarColorButtonOptions(
                customOnPressedCallback: (controller, isBackground) async {
                  _toggleColorPalette(false);
                },
              ),
              backgroundColor: QuillToolbarColorButtonOptions(
                customOnPressedCallback: (controller, isBackground) async {
                  _toggleColorPalette(true);
                },
              ),
            ),

            toolbarSectionSpacing: 4,
            multiRowsDisplay: false,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
      ],
    );
  }
}
