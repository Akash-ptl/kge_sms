import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_model.dart';
import 'package:sms/Api/api.dart';
import 'package:sms/utils/const.dart';
import '../global.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.simCard});
  final List<SimCard> simCard;
  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  RxBool loading = false.obs;

  @override
  void initState() {
    super.initState();
    cron = Cron();
    cron!.schedule(Schedule.parse('*/2 * * * *'), () async {
      print(DateTime.now());
      await SMSApi.sendApiRequest().then((value) async {
        _loadData();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadData() async {
    if (SMSApi.getSMBDataList.value.rows?[0].type == '0') {
      String time = DateTime.now().toLocal().toString();
      await SMSApi.updateData(context, DateTime.now().toLocal().toString(), SMSApi.getSMBDataList.value.rows?[0].uuid).then(
        (value) {
          sendSms(SMSApi.getSMBDataList.value.rows?[0].msgtext ?? '', SMSApi.getSMBDataList.value.rows?[0].receiverid ?? '', SMSApi.getSMBDataList.value.rows?[0].uuid ?? '',
                  SMSApi.getSMBDataList.value.rows?[0].type ?? '')
              .then(
            (value) async {
              print('updateData :: ${value}');
              if (value) {
                await SMSApi.updateData2(context, time.toString().trim(), SMSApi.getSMBDataList.value.rows?[0].uuid ?? '', DateTime.now().toLocal().toString(), 1).then((value) async {});
              } else {
                await SMSApi.updateData2(context, time.toString().trim(), SMSApi.getSMBDataList.value.rows?[0].uuid ?? '', 'INVALID NUMBER', 2).then((value) async {});
              }
            },
          );
        },
      );
      //   },
      // );
    } else {
      sendSms('BAL', '199', '', '').then((value) async {
        if (value) {
          Future.delayed(const Duration(minutes: 1)).then((value) async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  // SmsQueryKind.sent,
                ],
              );
              await SMSApi.updateData3(context, SMSApi.getSMBDataList.value.rows?[0].sent ?? '', SMSApi.getSMBDataList.value.rows?[0].uuid ?? '', SMSApi.getSMBDataList.value.rows?[0].delivered ?? '',
                      messages.first.body)
                  .then((value) async {});
              setState(() => _messages.add(messages.first));
            } else {
              await Permission.sms.request();
            }
          });
        } else {
          await SMSApi.updateData3(context, SMSApi.getSMBDataList.value.rows?[0].sent ?? '', SMSApi.getSMBDataList.value.rows?[0].uuid ?? '', '', 'INVALID NUMBER').then((value) async {});
        }
      });
    }
  }

  List<SmsMessage> _messages = [];

  int _simIndex = 0; // Keep track of the current SIM index

  Future<bool> sendSms(message, number, uuid, type) async {
    FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      if (Platform.isAndroid) {
        // Get the current SIM card

        final currentSim = widget.simCard[_simIndex];
        await Constants.nativeChannel.invokeMethod("sendSMS", {
          "mobileNumber": number == '199' ? '199' : number,
          // "mobileNumber": '111111111',
          // "mobileNumber": '9328895180',
          "message": number == '199'
              ? 'BAL'
              : (uuid != '')
                  ? '$message - UUID - $uuid - TYPE - $type'
                  : '$message',
          "subscriptionId": currentSim.subscriptionId.toString(),
        });
      }

      Map<String, dynamic> smsData = {
        'phoneNumber': number,
        'message': message,
        'sim': widget.simCard[_simIndex].subscriptionId.toString(),
        'uuid': uuid, // Add the UUID to the smsData map
      };
      String jsonEncoded = json.encode(smsData);
      print('jsonEncoded :: ${jsonEncoded}');

      final sentSmsCache = <String, bool>{};
      sentSmsCache[uuid] = true;

      _simIndex = (_simIndex + 1) % widget.simCard.length;

      return true;
    } catch (e) {
      _simIndex = (_simIndex + 1) % widget.simCard.length;

      return false;
    }
  }

  bool start = false;
  final SmsQuery _query = SmsQuery();
  Cron? cron;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              setState(() {});
              start = !start;

              if (start == true) {
                print('Start');
              } else {
                print('Stop');
              }
              if (start == true) {
                cron = Cron();
                cron!.schedule(Schedule.parse('*/2 * * * *'), () async {
                  print(DateTime.now());
                  await SMSApi.sendApiRequest().then((value) async {
                    _loadData();
                  });
                });
              } else {
                cron!.close();
                cron = null;
              }
            },
            child: (start == false) ? const Icon(Icons.play_arrow) : const Icon(Icons.stop),
          ),
          2.pw,
          FloatingActionButton(
            heroTag: 1,
            onPressed: () async {
              var permission = await Permission.sms.status;
              if (permission.isGranted) {
                final messages = await _query.querySms(
                  kinds: [
                    SmsQueryKind.inbox,
                  ],
                );

                setState(() => _messages = messages);
              } else {
                await Permission.sms.request();
              }
            },
            child: const Icon(Icons.refresh),
          ),
          2.pw,
          FloatingActionButton(
            heroTag: 2,
            child: const Icon(Icons.send),
            onPressed: () async {
              SMSApi.sendApiRequest().then((value) async {
                _loadData();
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        return loading.isFalse
            ? Padding(
                padding: EdgeInsets.all(h * 0.02),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      10.ph,
                      const Divider(
                        thickness: 3,
                      ),
                      const Text(
                        'Inbox Messages',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int i) {
                          var message = _messages[i];

                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('sender : ${message.sender}'),
                                Text('Date : ${message.date}'),
                                Text('Id : ${message.id}'),
                                Text('Thread Id : ${message.threadId} '),
                                Text('Status : ${message.read} '),
                                Text('kind : ${message.kind} '),
                                Text('address : ${message.address} '),
                                Text('dateSent : ${message.dateSent} '),
                                Text('date : ${message.date} '),
                                Text('Msg : ${message.body}'),
                                const Divider()
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
}
