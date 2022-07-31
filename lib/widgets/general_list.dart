import 'package:flutter/material.dart';
import 'package:inventory_management/constants.dart';

class GeneralList extends StatelessWidget {
  const GeneralList(
      {Key? key, required this.title, required this.onDeleteButtonPressed})
      : super(key: key);
  final String title;
  final VoidCallback onDeleteButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: kHeadingTextStyle.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: onDeleteButtonPressed,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
