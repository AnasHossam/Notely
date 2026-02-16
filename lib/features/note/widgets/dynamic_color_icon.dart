import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notely/core/theme/app_colors.dart';

class DynamicColorIcon extends StatefulWidget {
  const DynamicColorIcon({
    super.key,
    required this.controller,
    required this.isBackground,
    this.icon,
  });

  final QuillController controller;
  final bool isBackground;
  final IconData? icon;

  @override
  State<DynamicColorIcon> createState() => _DynamicColorIconState();
}

class _DynamicColorIconState extends State<DynamicColorIcon> {
  Color? _activeColor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeEditingValue);
    _updateActiveColor();
  }

  @override
  void didUpdateWidget(covariant DynamicColorIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _updateActiveColor();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    _updateActiveColor();
  }

  void _updateActiveColor() {
    final style = widget.controller.getSelectionStyle();
    final attribute = widget.isBackground
        ? style.attributes[Attribute.background.key]
        : style.attributes[Attribute.color.key];

    Color? newColor;
    if (attribute != null && attribute.value != null) {
      try {
        String hex = attribute.value as String;
        hex = hex.replaceFirst('#', '');
        if (hex.length == 6) {
          hex = 'FF$hex';
        }
        newColor = Color(int.parse(hex, radix: 16));
      } catch (e) {
        //
      }
    }

    if (newColor != _activeColor) {
      setState(() {
        _activeColor = newColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.textPrimaryLightColor;

    IconData iconData;
    Color iconColor;

    if (widget.isBackground) {
      if (_activeColor != null) {
        iconData = Icons.format_color_fill;
        iconColor = _activeColor!;
      } else {
        iconData = Icons.format_color_reset;
        iconColor = defaultTextColor;
      }
    } else {
      iconData = widget.icon ?? Icons.format_color_text;
      iconColor = _activeColor ?? defaultTextColor;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }
}
