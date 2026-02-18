import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:notely/core/utils/file_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notely/core/theme/app_colors.dart';
import 'package:notely/features/note/widgets/dynamic_color_icon.dart';

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({
    super.key,
    required this.controller,
    this.isTop = false,
    this.onImagePickStart,
    this.onImagePickEnd,
    this.onImageInserted,
  });

  final QuillController controller;
  final bool isTop;
  final VoidCallback? onImagePickStart;
  final VoidCallback? onImagePickEnd;
  final VoidCallback? onImageInserted;

  @override
  State<NoteToolbar> createState() => _NoteToolbarState();
}

class _NoteToolbarState extends State<NoteToolbar> {
  bool _isColorPaletteVisible = false;
  bool _isBackgroundMode = false;

  Future<void> _pickImage() async {
    widget.onImagePickStart?.call();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final savedPath = await FileUtils.saveImageToAppDirectory(image);
        final index = widget.controller.selection.baseOffset;
        final length = widget.controller.selection.extentOffset - index;

        widget.controller.replaceText(index, length, '\n', null);
        widget.controller
            .replaceText(index + 1, 0, BlockEmbed.image(savedPath), null);
        widget.controller.replaceText(index + 2, 0, '\n', null);

        widget.controller.updateSelection(
            TextSelection.collapsed(offset: index + 3), ChangeSource.local);
        widget.onImageInserted?.call();
      }
    } finally {
      widget.onImagePickEnd?.call();
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

  void _applyColor(Color? color) {
    if (color == null) {
      if (_isBackgroundMode) {
        widget.controller.formatSelection(const BackgroundAttribute(null));
      } else {
        widget.controller.formatSelection(const ColorAttribute(null));
      }
    } else {
      final hex = '#${color.toARGB32().toRadixString(16).substring(2)}';
      if (_isBackgroundMode) {
        widget.controller.formatSelection(BackgroundAttribute(hex));
      } else {
        widget.controller.formatSelection(ColorAttribute(hex));
      }
    }
    setState(() {
      _isColorPaletteVisible = false;
    });
  }

  Widget _buildToolbarRow() {
    if (kIsWeb) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Group 1: Style
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.bold,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.italic,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.underline,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 16),

          // Group 2: Lists
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.ul,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.unchecked,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconData: Icons.check_box_outlined,
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 16),

          // Group 3: Colors
          IconButton(
            icon: DynamicColorIcon(
              controller: widget.controller,
              isBackground: false,
            ),
            onPressed: () => _toggleColorPalette(false),
            color: AppColors.textPrimaryLightColor,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: DynamicColorIcon(
              controller: widget.controller,
              isBackground: true,
            ),
            onPressed: () => _toggleColorPalette(true),
            color: AppColors.textPrimaryLightColor,
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 16),

          // Group 4: Image
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () => _pickImage(),
            color: AppColors.textPrimaryLightColor,
          ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Group 1: Style (Bold, Italic, Underline)
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.bold,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.italic,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.underline,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 8),

          // Group 2: Lists (Bullet, Checkbox)
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.ul,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          QuillToolbarToggleStyleButton(
            controller: widget.controller,
            attribute: Attribute.unchecked,
            options: const QuillToolbarToggleStyleButtonOptions(
              iconData: Icons.check_box_outlined,
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColors.textPrimaryLightColor,
                ),
                iconButtonSelectedData: IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 8),

          // Group 3: Colors (Text, Background)
          IconButton(
            icon: DynamicColorIcon(
              controller: widget.controller,
              isBackground: false,
            ),
            onPressed: () => _toggleColorPalette(false),
            color: AppColors.textPrimaryLightColor,
          ),
          IconButton(
            icon: DynamicColorIcon(
              controller: widget.controller,
              isBackground: true,
            ),
            onPressed: () => _toggleColorPalette(true),
            color: AppColors.textPrimaryLightColor,
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: AppColors.textSecondaryLightColor.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 8),

          // Group 4: Image
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () => _pickImage(),
            color: AppColors.textPrimaryLightColor,
          ),
        ],
      ),
    );
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
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.green,
    ];

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: InkWell(
                onTap: () => _applyColor(null),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
              ),
            ),
            // Colors
            ...colors.map((color) {
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
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.isTop
          ? const BorderRadius.vertical(bottom: Radius.circular(20))
          : const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            borderRadius: widget.isTop
                ? const BorderRadius.vertical(bottom: Radius.circular(20))
                : const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: widget.isTop
                  ? BorderSide.none
                  : BorderSide(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
              bottom: widget.isTop
                  ? BorderSide(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : BorderSide.none,
              left: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
              right: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isTop) _buildColorPalette(),
              _buildToolbarRow(),
              if (widget.isTop) _buildColorPalette(),
            ],
          ),
        ),
      ),
    );
  }
}
