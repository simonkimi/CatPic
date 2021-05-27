import 'package:flutter/material.dart';

class SelectItem<T> {
  const SelectItem({required this.title, required this.value});

  final String title;
  final T value;
}

class SelectTile<T> extends StatelessWidget {
  const SelectTile({
    Key? key,
    required this.title,
    required this.dialogTitle,
    required this.items,
    this.leading,
    required this.value,
  }) : super(key: key);

  final String dialogTitle;
  final Widget? title;
  final List<SelectItem<T>> items;
  final Widget? leading;

  final T value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      leading: leading,
    );
  }
}
