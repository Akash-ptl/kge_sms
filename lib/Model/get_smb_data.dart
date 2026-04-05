// To parse this JSON data, do
//
//     final getSmbData = getSmbDataFromJson(jsonString);

import 'dart:convert';

GetSmbData getSmbDataFromJson(String str) =>
    GetSmbData.fromJson(json.decode(str));

String getSmbDataToJson(GetSmbData data) => json.encode(data.toJson());

class GetSmbData {
  String? status;
  String? response;
  List<SmsRow>? rows;

  GetSmbData({
    this.status,
    this.response,
    this.rows,
  });

  factory GetSmbData.fromJson(Map<String, dynamic> json) => GetSmbData(
        status: json["STATUS"],
        response: json["RESPONSE"],
        rows: json["ROWS"] == null
            ? []
            : List<SmsRow>.from(json["ROWS"]!.map((x) => SmsRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "RESPONSE": response,
        "ROWS": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class SmsRow {
  String? smbDataId;
  String? uuid;
  String? senderid;
  String? receiverid;
  String? msgtext;
  String? type;
  DateTime? received;
  String? sent;
  String? delivered;
  String? result;
  String? deviceid;
  String? marksent;
  String? status;
  DateTime? edrInsertTime;

  SmsRow({
    this.smbDataId,
    this.uuid,
    this.senderid,
    this.receiverid,
    this.msgtext,
    this.type,
    this.received,
    this.sent,
    this.delivered,
    this.result,
    this.deviceid,
    this.marksent,
    this.status,
    this.edrInsertTime,
  });

  factory SmsRow.fromJson(Map<String, dynamic> json) => SmsRow(
        smbDataId: json["SMBDataID"],
        uuid: json["UUID"],
        senderid: json["SENDERID"],
        receiverid: json["RECEIVERID"],
        msgtext: json["MSGTEXT"],
        type: json["TYPE"],
        received:
            json["RECEIVED"] == null ? null : DateTime.parse(json["RECEIVED"]),
        sent: json["SENT"],
        delivered: json["DELIVERED"],
        result: json["RESULT"],
        deviceid: json["DEVICEID"],
        marksent: json["MARKSENT"],
        edrInsertTime: json["EDRInsertTime"] == null
            ? null
            : DateTime.parse(json["EDRInsertTime"]),
      );

  Map<String, dynamic> toJson() => {
        "SMBDataID": smbDataId,
        "UUID": uuid,
        "SENDERID": senderid,
        "RECEIVERID": receiverid,
        "MSGTEXT": msgtext,
        "TYPE": type,
        "RECEIVED": received?.toIso8601String(),
        "SENT": sent,
        "DELIVERED": delivered,
        "RESULT": result,
        "DEVICEID": deviceid,
        "MARKSENT": marksent,
        "EDRInsertTime": edrInsertTime?.toIso8601String(),
      };
}
