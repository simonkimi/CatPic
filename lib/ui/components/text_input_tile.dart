import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'default_button.dart';

class TextInputTile extends StatefulWidget {
  const TextInputTile({
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    required this.onChanged,
    this.dialogTitle,
    this.hintText,
    this.labelText,
    this.defaultValue,
    this.positiveText,
    this.negativeText,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final ValueChanged<String> onChanged;

  final Widget? dialogTitle;
  final String? hintText;
  final String? labelText;

  final String? defaultValue;

  final String? positiveText;
  final String? negativeText;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  _TextInputTileState createState() => _TextInputTileState();
}

class _TextInputTileState extends State<TextInputTile> {
  var controller = TextEditingController();
  late String value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue ?? '';
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      onTap: () {
        _showDialog(context);
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: widget.dialogTitle,
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      labelText: widget.labelText,
                    ),
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(widget.negativeText ?? I18n.of(context).negative),
              ),
              DefaultButton(
                onPressed: () {
                  widget.onChanged(controller.text);
                  Navigator.of(context).pop();
                },
                child: Text(widget.positiveText ?? I18n.of(context).positive),
              )
            ],
          );
        });
  }
}
