import 'package:flutter/material.dart';
import 'package:nit_scholar/utils/color_util.dart';

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const CircleCheckbox({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: value ? MinColor.fromHex("#0882F8") : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: value
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16.0,
              )
            : null,
      ),
    );
  }
}
