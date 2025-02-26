import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BlaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final String type;
  final IconData? icon;
  final bool disabled;

  const BlaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = 'primary',
    this.icon,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;

    if (disabled) {
      buttonColor = BlaColors.disabled;
    } else {
      buttonColor = type == 'primary' ? BlaColors.primary : BlaColors.neutral;
    }

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: EdgeInsets.symmetric(
          horizontal: BlaSpacings.m, vertical: BlaSpacings.s),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
      ),
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: disabled ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: BlaColors.white),
            SizedBox(width: BlaSpacings.s),
          ],
          Text(
            label,
            style: BlaTextStyles.button.copyWith(
              color: BlaColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
