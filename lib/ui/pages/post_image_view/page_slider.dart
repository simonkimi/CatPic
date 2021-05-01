import 'package:flutter/material.dart';

class PageSliderController {
  late PageSliderState _state;

  void setValue(int newValue) {
    _state.setPage(newValue + 1);
  }
}

class PageSlider extends StatefulWidget {
  const PageSlider({
    Key? key,
    required this.count,
    required this.value,
    this.onChange,
    this.controller,
  }) : super(key: key);

  final int count;
  final int value;
  final ValueChanged<int>? onChange;
  final PageSliderController? controller;

  @override
  PageSliderState createState() => PageSliderState();
}

class PageSliderState extends State<PageSlider> {
  late int value = widget.value;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  void setPage(int newValue) {
    print('setPage $newValue');
    setState(() {
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Slider(
              onChangeEnd: (value) {
                print('end: $value');
                widget.onChange?.call(value.toInt());
              },
              value: value.toDouble(),
              max: widget.count.toDouble(),
              min: 1.0,
              divisions: widget.count - 1,
              onChanged: (v) {
                setState(() {
                  value = v.toInt();
                });
              },
            ),
          ),
          Text(
            widget.count.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
