import 'package:flutter/material.dart';

class DropDownList extends StatelessWidget {
  const DropDownList({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
  }) : super(key: key);
  final String title;
  final List<String> items;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        hint: Text(title),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>(
          (value) {
            return DropdownMenuItem(value: value, child: Text(value));
          },
        ).toList(),
      ),
    );
  }
}
