import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';

class HostManagerPage extends StatelessWidget {
  static const route = 'HostManagerPage';
  final database = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<HostTableData>>(
      initialData: const [],
      stream: database.hostDao.getAllStream(),
      builder: (context, s) {
        print(s.data);
        return ListView(
          children: s.data!.map((e) {
            return Dismissible(
              key: ValueKey(e.id),
              child: ListTile(
                title: Text(e.host),
                subtitle: Text(e.ip),
              ),
              onDismissed: (_) {
                DatabaseHelper().hostDao.remove(e);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      tooltip: I18n.of(context).add,
      onPressed: () {
        _showDialog(context);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        I18n.of(context).host_manager,
        style: const TextStyle(fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        tooltip: I18n.of(context).back,
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) {
          final hostController = TextEditingController();
          final ipController = TextEditingController();
          return StatefulBuilder(builder: (context, localState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    TextField(
                      controller: hostController,
                      decoration: const InputDecoration(
                        labelText: 'Host',
                        hintText: 'example.com',
                      ),
                    ),
                    TextField(
                      controller: ipController,
                      decoration: const InputDecoration(
                        labelText: 'IP',
                        hintText: '12.34.56.78',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.autorenew_sharp),
                  onPressed: () async {
                    final host = hostController.text.getHost();
                    final cancelFunc = BotToast.showLoading();
                    final hostValue = await getDoH(host);
                    cancelFunc();
                    if (hostValue.isNotEmpty) {
                      localState(() {
                        ipController.text = hostValue;
                      });
                    } else {
                      BotToast.showText(
                          text: I18n.of(context).trusted_host_auto_failed);
                    }
                  },
                ),
                DefaultButton(
                  onPressed: () {
                    saveHost(
                            host: hostController.text.getHost(),
                            ip: ipController.text,
                            context: context)
                        .then((value) {
                      if (value) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(I18n.of(context).positive),
                ),
              ],
            );
          });
        });
  }

  Future<bool> saveHost(
      {required String host,
      required String ip,
      required BuildContext context}) async {
    if (host.isEmpty || ip.isEmpty) {
      BotToast.showText(text: I18n.of(context).host_empty);
      return false;
    }
    final reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
    if (!reg.hasMatch(ip)) {
      BotToast.showText(text: I18n.of(context).illegal_ip);
      return false;
    }
    final dao = DatabaseHelper().hostDao;

    final oldHost = await dao.getByHost(host);
    if (oldHost != null) {
      await dao.remove(oldHost);
    }
    final hostEntity =
        HostTableCompanion.insert(host: host, ip: ip, websiteId: -1);
    await dao.insert(hostEntity);
    return true;
  }
}
