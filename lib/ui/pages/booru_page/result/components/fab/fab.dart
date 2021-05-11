import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';

class FloatActionBubble extends StatelessWidget {
  const FloatActionBubble({
    Key? key,
    required this.loadMoreStore,
  }) : super(key: key);
  final ILoadMore loadMoreStore;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      backgroundColor:
          isDarkMode(context) ? const Color(0xFF616161) : Colors.white,
      foregroundColor:
          isDarkMode(context) ? const Color(0xFFFDFDFD) : Colors.black,
      overlayColor: Colors.transparent,
      overlayOpacity: 0.5,
      children: [
        if (mainStore.searchPageCount > 1 && Navigator.canPop(context))
          SpeedDialChild(
            backgroundColor:
                isDarkMode(context) ? const Color(0xFF616161) : Colors.white,
            foregroundColor:
                isDarkMode(context) ? const Color(0xFFFDFDFD) : Colors.black,
            child: const Icon(Icons.first_page),
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),
        SpeedDialChild(
          backgroundColor:
              isDarkMode(context) ? const Color(0xFF616161) : Colors.white,
          foregroundColor:
              isDarkMode(context) ? const Color(0xFFFDFDFD) : Colors.black,
          child: const Icon(Icons.refresh),
          onTap: () async {
            await loadMoreStore.onRefresh();
          },
        ),
        SpeedDialChild(
          backgroundColor:
              isDarkMode(context) ? const Color(0xFF616161) : Colors.white,
          foregroundColor:
              isDarkMode(context) ? const Color(0xFFFDFDFD) : Colors.black,
          child: const Icon(Icons.find_in_page_outlined),
          onTap: () async {
            final page = await showDialog(
                context: context,
                builder: (context) {
                  final inputController = TextEditingController();
                  return AlertDialog(
                    title: Text(I18n.of(context).jump_page),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          TextField(
                            controller: inputController,
                            decoration: InputDecoration(
                              hintText: loadMoreStore.page.toString(),
                              labelText: I18n.of(context).page,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(I18n.of(context).negative),
                      ),
                      DefaultButton(
                        onPressed: () {
                          if (inputController.text.isEmpty) {
                            Navigator.of(context).pop();
                            return;
                          }
                          Navigator.of(context)
                              .pop(int.tryParse(inputController.text) ?? 1);
                        },
                        child: Text(I18n.of(context).positive),
                      )
                    ],
                  );
                });
            if (page != null) {
              loadMoreStore.onJumpPage(page);
            }
          },
        ),
        SpeedDialChild(
          backgroundColor:
              isDarkMode(context) ? const Color(0xFF616161) : Colors.white,
          foregroundColor:
              isDarkMode(context) ? const Color(0xFFFDFDFD) : Colors.black,
          child: const Icon(Icons.keyboard_arrow_up),
          onTap: () async {
            loadMoreStore.listScrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }
}
