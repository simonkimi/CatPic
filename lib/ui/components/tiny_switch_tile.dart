import 'package:flutter/material.dart';

class TinySwitchTile extends StatelessWidget {
  const TinySwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final Widget title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          SizedBox(
            height: 40,
            child: Switch(
              value: true,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
