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
  List<Row>? rows;

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
            : List<Row>.from(json["ROWS"]!.map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "RESPONSE": response,
        "ROWS": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
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
  DateTime? edrInsertTime;

  Row({
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
    this.edrInsertTime,
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
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
