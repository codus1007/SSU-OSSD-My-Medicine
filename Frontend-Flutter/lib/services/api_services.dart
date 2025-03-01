import 'dart:convert';
import 'dart:developer';
// import 'dart:ffi';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/prescription_model.dart';
import 'package:medicineapp/models/user_model.dart';

class ApiService {
  static const String baseUrl = '141.164.62.81:5000';

  Future<int> pingServer() async {
    final url = Uri.http(baseUrl, '/ping');
    final response = await http.get(url);
    log("/ping: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode != 204) {
      log('Server Response : ${response.statusCode}');
    }
    return response.statusCode;
  }

  Future<int> login(String loginId, String password) async {
    final url = Uri.http(baseUrl, '/login', {
      'loginId': loginId,
      'password': password,
    });
    final response = await http.get(url);
    log("/login: REQ: $url");
    log("/login: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode != 200) {
      log('Server Response : ${response.statusCode}');

      return -1;
    } else {
      Map<String, dynamic> uidData = jsonDecode(response.body);
      int uidValue = uidData["uid"];

      return uidValue;
    }
  }

  Future<UserModel> getUserInfo(int uid) async {
    final url = Uri.http(baseUrl, '/getUserInfo', {'uid': '$uid'});
    log(url.toString());
    final response = await http.get(url);
    log("/getUserInfo: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      log(resData.toString());

      final userData = UserModel.fromJson(resData);
      return userData;
    }
    throw Error();
  }

// get list of prescriptions
  Future<PrescListModel> getPrescList(int uid) async {
    final url = Uri.http(baseUrl, '/getPrescList', {'uid': '$uid'});
    final response = await http.get(url);
    log("/getPrescList: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);

      final prescData = PrescListModel.fromJson(resData);
      return prescData;
    }
    log("getPrescList Error: ${response.statusCode}");
    throw Error();
  }

// get detailed information of a prescription
  Future<PrescModel> getPrescInfo(int prescId) async {
    final url = Uri.http(baseUrl, '/getPrescInfo', {'prescId': '$prescId'});
    final response = await http.get(url);
    log("/getPrescInfo: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body)[0];

      final prescData = PrescModel.fromJson(resData);
      return prescData;
    }
    log("getPrescInfo Error: ${response.statusCode}");
    throw Error();
  }

  Future<Uint8List> getPrescPic(int prescId) async {
    final url = Uri.http(baseUrl, '/getPrescPic', {'prescId': '$prescId'});
    final response = await http.get(url);
    // log("/getPrescPic: <${response.statusCode}>, <${response.body}>");
    log("/getPrescPic: <${response.statusCode}>, ${response.body.length}B");
    if (response.statusCode == 200) {
      Uint8List resData = base64Decode(response.body);
      // final resData = response.body;
      return resData;
    }
    log("getPrescPic Error: ${response.statusCode}");
    throw Error();
  }

  // String getPrescPicLink(int prescId) {
  //   String url = "http://141.164.62.81:5000/getPrescPic?prescId=$prescId";
  //   log("getPrescPicLink: $url");

  //   return url;
  // }

  // Future<String> getPrescPicLink(int prescId) async {
  //   final url = Uri.http(baseUrl, '/getPrescPicLink', {'id': '$prescId'});
  //   final response = await http.get(url);
  //   log("/getPrescPicLink: <${response.statusCode}>, <${response.body}>");
  //   if (response.statusCode == 200) {
  //     final resData = response.body;
  //     return resData;
  //   }
  //   log("getPrescPic Error: ${response.statusCode}");
  //   throw Error();
  // }
}
