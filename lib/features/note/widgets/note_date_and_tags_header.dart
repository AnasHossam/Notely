import 'package:flutter/material.dart';
import 'package:notely/core/widgets/custom_dialog.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class NoteDateAndTagsHeader extends StatelessWidget {
  const NoteDateAndTagsHeader({
    super.key,
    required this.date,
    this.tag,
    required this.onTagChanged,
  });

  final String date;
  final String? tag;
  final ValueChanged<String?> onTagChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (tag != null && tag!.isNotEmpty)
          _buildTagContainer(context)
        else
          _buildAddTagButton(context),
      ],
    );
  }

  Widget _buildTagContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkTheme(context)
            ? AppColors.primaryDarkColor
            : AppColors.primaryLightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onTagChanged(null),
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).textTheme.labelSmall?.color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            tag!,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAddTagButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddTagDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDarkTheme(context)
              ? AppColors.primaryDarkColor.withValues(alpha: 0.3)
              : AppColors.primaryLightColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "+ Tag",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Add Tag",
          icon: Icons.label,
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter tag name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onTagChanged(controller.text.trim());
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
