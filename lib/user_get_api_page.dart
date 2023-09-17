import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserGetApiPage extends StatelessWidget {
  UserGetApiPage({super.key});

  final UserGetApiController userGetApiController =
      Get.put(UserGetApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<UserGetApiController>(builder: (_) {
      return userGetApiController.userDataList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userGetApiController.userDataList.length,
              itemBuilder: (context, index) {
                return Text(
                    userGetApiController.userDataList[index].name.toString());
              });
    }));
  }
}

//
class UserGetApiController extends GetxController {
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  RxList userDataList = <UserData>[].obs;
  getData() async {
    var data = await UserGetApi().get('/users');
    userDataList.addAll(data);
    update();
  }
}

//
class UserGetApi {
  var client = http.Client();

  Future<dynamic> get(String api) async {
    var baseUrl = 'https://631c37911b470e0e12fcdd0b.mockapi.io/api';
    var url = Uri.parse(baseUrl + api);
    var headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List data = await json.decode(response.body);
        List<UserData> list =
            data.map((val) => UserData.fromJson(val)).toList();

        return list;
      } else {
        print("Err::");
      }
    } catch (e) {
      print("E:::${e}");
    }
  }
}

//
class UserData {
  String? createdAt;
  String? name;
  String? avatar;
  String? id;
  List<Qualifications>? qualifications;

  UserData(
      {this.createdAt, this.name, this.avatar, this.id, this.qualifications});

  UserData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    name = json['name'];
    avatar = json['avatar'];
    id = json['id'];
    if (json['qualifications'] != null) {
      qualifications = <Qualifications>[];
      json['qualifications'].forEach((v) {
        qualifications!.add(new Qualifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['id'] = this.id;
    if (this.qualifications != null) {
      data['qualifications'] =
          this.qualifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualifications {
  String? degree;
  String? completionData;

  Qualifications({this.degree, this.completionData});

  Qualifications.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    completionData = json['completionData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree'] = this.degree;
    data['completionData'] = this.completionData;
    return data;
  }
}
