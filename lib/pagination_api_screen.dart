import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class PaginationApiScreen extends StatelessWidget {
  final PaginationController controller = Get.put(PaginationController());

  PaginationApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            controller: controller.scrollController,
            itemCount: controller.isLoadingMore.value
                ? controller.posts.length + 1
                : controller.posts.length,
            itemBuilder: (context, index) {
              if (index < controller.posts.length) {
                final post = controller.posts[index];

                return Card(
                  margin: const EdgeInsets.all(20),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post.avatar.toString()),
                    ),
                    title: Text(post.email.toString()),
                    subtitle: Text("${post.firstName} ${post.lastName}"),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
      }),
    );
  }
}

class PaginationController extends GetxController {
  final scrollController = ScrollController();
  List<Data> posts = <Data>[].obs;
  var page = 1.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    scrollController.addListener(scrollListener);
    fetchdata();
    super.onInit();
  }

  fetchdata() async {
    final url = 'https://reqres.in/api/users?page=${page.value}';

    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List a = json['data'];
      List<Data> data = a.map((e) => Data.fromJson(e)).toList();
      posts.addAll(data);
    }
  }

  scrollListener() async {
    if (isLoadingMore.value) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      page.value = page.value + 1;
      await fetchdata();
      isLoadingMore.value = false;
    }
  }
}

class Data {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  Data({this.id, this.email, this.firstName, this.lastName, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    return data;
  }
}
