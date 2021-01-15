import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';

class HostManagerPage extends StatefulWidget {
  static var routeName = 'HostManager';

  @override
  _HostManagerPageState createState() => _HostManagerPageState();
}

class _HostManagerPageState extends State<HostManagerPage> {
  List<HostEntity> hostEntities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: buildBody(),
    );
  }

  ListView buildBody() {
    return ListView(
      children: hostEntities?.map((e) {
        return Dismissible(
          key: ValueKey(e.id),
          child: ListTile(
            title: Text(e.host),
            subtitle: Text(e.ip),
          ),
          onDismissed: (_) {
            DatabaseHelper().hostDao.removeHost([e]).then((value) {
              init();
            });
          },
        );
      })?.toList() ?? [],
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: S.of(context).add,
      onPressed: () {
        _showDialog();
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).host_manager),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
        tooltip: S.of(context).back,
      ),
    );
  }

  Future<void> init() async {
    var hostDao = DatabaseHelper().hostDao;
    hostEntities = await hostDao.getAll();
    setState(() {});
  }

  Future<void> _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          var hostController = TextEditingController();
          var ipController = TextEditingController();
          var sni = false;
          return StatefulBuilder(builder: (context, localState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    TextField(
                      controller: hostController,
                      decoration: InputDecoration(
                        labelText: "Host",
                        hintText: "example.com",
                      ),
                    ),
                    TextField(
                      controller: ipController,
                      decoration: InputDecoration(
                        labelText: "IP",
                        hintText: "12.34.56.78",
                      ),
                    ),
                    SwitchListTile(
                      value: sni,
                      onChanged: (value) {
                        localState(() {
                          sni = value;
                        });
                      },
                      title: Text(
                        S.of(context).domain_fronting,
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.autorenew_sharp),
                  onPressed: () {
                    var host = getHost(hostController.text);
                    var cancelFunc = BotToast.showLoading();
                    getTrustHost(host).then((value) {
                      cancelFunc();
                      if (value.isNotEmpty) {
                        localState(() {
                          ipController.text = value;
                        });
                      } else {
                        BotToast.showText(
                            text: S.of(context).trusted_host_auto_failed);
                      }
                    });
                  },
                ),
                FlatButton(
                  onPressed: () {
                    saveHost(
                            host: getHost(hostController.text),
                            ip: ipController.text,
                            useSni: sni)
                        .then((value) {
                      if (value) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(S.of(context).confirm),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            );
          });
        });
  }

  Future<bool> saveHost({String host, String ip, bool useSni}) async {
    if (host.isEmpty || ip.isEmpty) {
      BotToast.showText(text: S.of(context).host_empty);
      return false;
    }
    var reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
    if (!reg.hasMatch(ip)) {
      BotToast.showText(text: S.of(context).illegal_ip);
      return false;
    }
    var dao = DatabaseHelper().hostDao;
    await dao.removeHost([await dao.getByHost(host)]);
    var hostEntity = HostEntity(host: host, ip: ip, sni: useSni);
    await dao.addHost(hostEntity);
    await init();
    return true;
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
