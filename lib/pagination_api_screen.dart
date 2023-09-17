import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class PaginationApiScreen extends StatelessWidget {
  final PaginationController controller = Get.put(PaginationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (controller.posts.isEmpty) {
          return Center(child: CircularProgressIndicator());
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
                final title = post['title']['rendered'];
                return ListTile(
                  title: Text(title),
                );
              } else {
                return Center(
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
  var posts = [].obs;
  var page = 1.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    scrollController.addListener(scrollListener);
    fetchdata();
    super.onInit();
  }

  fetchdata() async {
    final url =
        'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=10&page=${page.value}';

    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      posts.addAll(json);
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
