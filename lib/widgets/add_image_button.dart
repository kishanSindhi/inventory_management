import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
