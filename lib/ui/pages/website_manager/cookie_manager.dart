import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/ui/pages/website_manager/store/website_add_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CookieManagerPage extends StatelessWidget {
  const CookieManagerPage({
    Key? key,
    required this.store,
  }) : super(key: key);
  static const route = 'CookieManagerPage';

  final WebsiteAddStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Observer(
      builder: (context) {
        return ListView(
          children: store.cookies.entries.map((e) {
            return Dismissible(
              key: ValueKey(e.key),
              child: ListTile(
                title: Text(e.key),
                subtitle: Text(e.value),
              ),
              onDismissed: (_) {
                store.cookies.remove(e.key);
              },
            );
          }).toList(),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Cookie',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      leading: appBarBackButton(),
      actions: [
        IconButton(
            onPressed: () {
              importCookieDialog(context);
            },
            icon: const Icon(
              Icons.input,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {
              inputCookieDialog(context);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ],
    );
  }

  Future<void> inputCookieDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) {
          final keyController = TextEditingController();
          final valueController = TextEditingController();
          return StatefulBuilder(builder: (context, localState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    TextField(
                      controller: keyController,
                      decoration: InputDecoration(
                        labelText: I18n.of(context).key,
                      ),
                    ),
                    TextField(
                      controller: valueController,
                      decoration: InputDecoration(
                        labelText: I18n.of(context).value,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                DefaultButton(
                  onPressed: () {
                    if (keyController.text.isNotEmpty &&
                        valueController.text.isNotEmpty) {
                      store.cookies[keyController.text] = valueController.text;
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(I18n.of(context).positive),
                ),
              ],
            );
          });
        });
  }

  Future<void> importCookieDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) {
          final cookieController = TextEditingController();
          return StatefulBuilder(builder: (context, localState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    TextField(
                      controller: cookieController,
                      decoration: InputDecoration(
                        labelText: I18n.of(context).import,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                DefaultButton(
                  onPressed: () {
                    if (cookieController.text.isNotEmpty &&
                        cookieController.text.contains('=')) {
                      store.cookies.addEntries(cookieController.text
                          .split(';')
                          .where((e) => e.isNotEmpty)
                          .map((e) {
                        final data = e.split('=');
                        return MapEntry(
                            data[0].trim(), data.skip(1).join('=').trim());
                      }));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(I18n.of(context).positive),
                ),
              ],
            );
          });
        });
  }
}
