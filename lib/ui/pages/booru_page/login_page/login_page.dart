import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:flutter/material.dart';

class BooruLoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          I18n.of(context).login,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        leading: appBarBackButton(),
      ),
      body: Container(
        child: Center(
          child: Card(
            child: Container(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      mainStore.websiteEntity!.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration:
                          InputDecoration(labelText: I18n.of(context).username),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: getPasswordTitle()),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          width: 65,
                          height: 35,
                          child: DefaultButton(
                            child: Text(I18n.of(context).save),
                            onPressed: () async {
                              final site = mainStore.websiteEntity!;
                              final newSite = site.copyWith(
                                username: _usernameController.text.isNotEmpty
                                    ? _usernameController.text
                                    : null,
                                password: _passwordController.text.isNotEmpty
                                    ? _passwordController.text
                                    : null,
                              );
                              await DB().websiteDao.updateSite(newSite);
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getPasswordTitle() {
    final site = mainStore.websiteEntity!;
    if (site.type == WebsiteType.MOEBOORU)
      return I18n.g.password;
    else if (site.type == WebsiteType.DANBOORU) return I18n.g.api_key;
    return 'Password';
  }
}
