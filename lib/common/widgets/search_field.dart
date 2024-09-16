import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.onSubmit,
    this.onChanged,
  });
  final void Function(String value)? onChanged;
  final TextEditingController textEditingController;
  final String hintText;
  final void Function(String value)? onSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: TextField(
        controller: textEditingController,
        onSubmitted: onSubmit,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(HugeIcons.strokeRoundedSearch02),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: _buildSuffixIcon(),
        ),
      ),
    );
  }

  Padding _buildSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: IconButton(
        onPressed: () {
          textEditingController.clear();
        },
        icon: const Icon(HugeIcons.strokeRoundedCancelCircle),
      ),
    );
  }
}
