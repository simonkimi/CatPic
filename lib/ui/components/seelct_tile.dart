import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';

class SelectTileItem<T> {
  const SelectTileItem({required this.title, required this.value});

  final String title;
  final T value;
}

class SelectTile<T> extends StatelessWidget {
  const SelectTile({
    Key? key,
    required this.title,
    required this.items,
    this.leading,
    required this.selectedValue,
    required this.onChange,
  }) : super(key: key);

  final String title;
  final List<SelectTileItem<T>> items;
  final Widget? leading;

  final T selectedValue;

  final ValueChanged<T> onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leading,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            items.get((e) => e.value == selectedValue)?.title ?? '无',
          ),
          const SizedBox(width: 5),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const Divider(height: 0),
                    ...items.map(
                      (e) => RadioListTile<T>(
                        value: e.value,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          onChange(value!);
                          Navigator.of(context).pop();
                        },
                        title: Text(e.title),
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
