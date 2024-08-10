import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;

import '../Model/get_smb_data.dart';

class SMSApi {
  static Rx<GetSmbData> getSMBDataList = GetSmbData().obs;

  static Future<void> sendApiRequest() async {
    print('Sending API request...');

    var url = 'https://dev-alphasms.breelink.com:4444';
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var body = {
      'UserName': 'test001',
      'Password': 'abcd1234',
      'apipoint': 'smbget',
      'MAXROWS': '1',
    };

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print('API response status code: ${response.statusCode}');
      print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        getSMBDataList(getSmbDataFromJson(response.body));

        print('API request successful!  ${getSMBDataList.value.rows?.length}');
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }

  static Future<void> signUp(context, userName, password) async {
    FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard

    try {
      const url = 'https://dev-alphasms.breelink.com:4444';
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final body = {
        'apipoint': 'authadd',
        'UserName': userName,
        'Password': password,
      };

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      final jsonData = json.decode(response.body);
      if (jsonData['STATUS'] != 'error') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(jsonData['TEXT'].toString()),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(jsonData['TEXT'].toString()),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<bool> updateData(context, sent, uuid) async {
    var url = 'https://dev-alphasms.breelink.com:4444';
    var formData = {
      'apipoint': 'smbupdate',
      'UserName': 'test001',
      'Password': 'abcd1234',
      'UUID': uuid,
      'DEVICEID': '',
      'RESULT': '',
      'SENT': sent,
      'DELIVERED': ''
    };
    print('formData ${formData}');

    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: formData);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(jsonData['TEXT'].toString()),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        print('Request sent successfully! ${response.body}');
        return true;
      } else {
        print('Error sending request: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending request: $e');
      return false;
    }
  }

  static Future<bool> updateData2(context, sent, uuid, deliver, type) async {
    var url = 'https://dev-alphasms.breelink.com:4444';
    var formData = {
      'apipoint': 'smbupdate',
      'UserName': 'test001',
      'Password': 'abcd1234',
      'UUID': uuid,
      'DEVICEID': '',
      'RESULT': type == 2 ? '$deliver' : '',
      // 'SENT': sent,
      'DELIVERED': type == 1 ? '$deliver' : ''
    };
    print('formData updateData22${formData}');

    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: formData);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(jsonData['TEXT'].toString()),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        print('Request sent successfully updateData2! ${response.body}//');
        return true;
      } else {
        print('Error sending request updateData2: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending request updateData2: $e');
      return false;
    }
  }

  static Future<bool> updateData3(context, sent, uuid, deliver, result) async {
    var url = 'https://dev-alphasms.breelink.com:4444';
    var formData = {
      'apipoint': 'smbupdate',
      'UserName': 'test001',
      'Password': 'abcd1234',
      'UUID': uuid,
      'DEVICEID': '',
      'RESULT': result,
      'SENT': sent,
      'DELIVERED': deliver
    };
    print('formData updateData3${formData}');

    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: formData);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(jsonData['TEXT'].toString()),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        print('Request sent successfully updateData2! ${response.body}//');
        return true;
      } else {
        print('Error sending request updateData2: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending request updateData2: $e');
      return false;
    }
  }

  // static Future<bool> addSmbData(uuid, sender, receiver, message) async {
  //   var url = 'https://dev-alphasms.breelink.com:4444/';
  //   var formData = {
  //     'apipoint': 'smbadd',
  //     'UserName': 'test001',
  //     'Password': 'abcd1234',
  //     'UUID': uuid,
  //     'SENDERID': sender,
  //     'RECEIVERID': receiver,
  //     'MSGTEXT':
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
  //     'TYPE': '1',
  //     'DEVICEID': 'DEVICEID'
  //   };
  //
  //   try {
  //     var response = await http.post(Uri.parse(url),
  //         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //         body: formData);
  //
  //     if (response.statusCode == 200) {
  //       print('Request sent successfully!');
  //       return true;
  //     } else {
  //       print('Error sending request: ${response.statusCode}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error sending request: $e');
  //     return false;
  //   }
  // }
}
