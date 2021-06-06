import 'package:flutter/material.dart';

class TinySwitchTile extends StatelessWidget {
  const TinySwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.disable,
  }) : super(key: key);

  final Widget title;
  final bool value;
  final ValueChanged<bool> onChanged;

  final bool? disable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!(disable ?? false)) onChanged(!value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          SizedBox(
            height: 40,
            child: Switch(
              value: value,
              onChanged: (disable ?? false) ? null : onChanged,
            ),
          )
        ],
      ),
    );
  }
}
