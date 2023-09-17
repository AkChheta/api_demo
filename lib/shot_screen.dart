import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShotScreen extends StatefulWidget {
  const ShotScreen({super.key});

  @override
  State<ShotScreen> createState() => _ShotScreenState();
}

class _ShotScreenState extends State<ShotScreen> {
  List<Shotdata> shotdataList = [];

  getData() async {
    var data = await ApiData().getShots();

    setState(() {
      shotdataList.addAll(data);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: shotdataList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: shotdataList.length,
                itemBuilder: (context, index) {
                  return Text(shotdataList[index].channelName.toString());
                }));
  }
}

class ApiData {
  Future getShots() async {
    var url = Uri.parse('http://adtip2.qa.ad-tip.com/api/getshots/1');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        final List a = data['data'];

        List<Shotdata> shotList =
            a.map((val) => Shotdata.fromJson(val)).toList();

        return shotList;
      } else {
        print("ERROR:::::::::::::::");
      }
    } catch (e) {
      print("EEE:::::::::::::${e}");
    }
  }
}

class Shotdata {
  int? id;
  String? name;
  int? isShot;
  int? categoryId;
  int? videoChannel;
  String? videoLink;
  String? videoDesciption;
  int? totalViews;
  int? totalLikes;
  int? isActive;
  int? createdby;
  Null updatedby;
  String? createddate;
  Null updateddate;
  int? isLike;
  int? isView;
  int? channelFollow;
  String? adUrl;
  int? totalChannelLikes;
  int? totalChannelFollowers;
  int? totalChannelVideo;
  String? channelName;
  String? channelProfile;
  int? channedlId;
  int? totalFollowers;
  String? channelProfileCover;
  int? totalChannelShots;
  int? totalChannelViews;
  int? channelId;
  int? isUnlike;

  Shotdata(
      {this.id,
      this.name,
      this.isShot,
      this.categoryId,
      this.videoChannel,
      this.videoLink,
      this.videoDesciption,
      this.totalViews,
      this.totalLikes,
      this.isActive,
      this.createdby,
      this.updatedby,
      this.createddate,
      this.updateddate,
      this.isLike,
      this.isView,
      this.channelFollow,
      this.adUrl,
      this.totalChannelLikes,
      this.totalChannelFollowers,
      this.totalChannelVideo,
      this.channelName,
      this.channelProfile,
      this.channedlId,
      this.totalFollowers,
      this.channelProfileCover,
      this.totalChannelShots,
      this.totalChannelViews,
      this.channelId,
      this.isUnlike});

  Shotdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isShot = json['is_shot'];
    categoryId = json['category_id'];
    videoChannel = json['video_channel'];
    videoLink = json['video_link'];
    videoDesciption = json['video_desciption'];
    totalViews = json['total_views'];
    totalLikes = json['total_likes'];
    isActive = json['is_active'];
    createdby = json['createdby'];
    updatedby = json['updatedby'];
    createddate = json['createddate'];
    updateddate = json['updateddate'];
    isLike = json['is_like'];
    isView = json['is_view'];
    channelFollow = json['channel_follow'];
    adUrl = json['adUrl'];
    totalChannelLikes = json['total_channel_likes'];
    totalChannelFollowers = json['total_channel_followers'];
    totalChannelVideo = json['total_channel_video'];
    channelName = json['channelName'];
    channelProfile = json['channel_profile'];
    channedlId = json['channedlId'];
    totalFollowers = json['total_followers'];
    channelProfileCover = json['channelProfileCover'];
    totalChannelShots = json['totalChannelShots'];
    totalChannelViews = json['totalChannelViews'];
    channelId = json['channelId'];
    isUnlike = json['is_unlike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_shot'] = this.isShot;
    data['category_id'] = this.categoryId;
    data['video_channel'] = this.videoChannel;
    data['video_link'] = this.videoLink;
    data['video_desciption'] = this.videoDesciption;
    data['total_views'] = this.totalViews;
    data['total_likes'] = this.totalLikes;
    data['is_active'] = this.isActive;
    data['createdby'] = this.createdby;
    data['updatedby'] = this.updatedby;
    data['createddate'] = this.createddate;
    data['updateddate'] = this.updateddate;
    data['is_like'] = this.isLike;
    data['is_view'] = this.isView;
    data['channel_follow'] = this.channelFollow;
    data['adUrl'] = this.adUrl;
    data['total_channel_likes'] = this.totalChannelLikes;
    data['total_channel_followers'] = this.totalChannelFollowers;
    data['total_channel_video'] = this.totalChannelVideo;
    data['channelName'] = this.channelName;
    data['channel_profile'] = this.channelProfile;
    data['channedlId'] = this.channedlId;
    data['total_followers'] = this.totalFollowers;
    data['channelProfileCover'] = this.channelProfileCover;
    data['totalChannelShots'] = this.totalChannelShots;
    data['totalChannelViews'] = this.totalChannelViews;
    data['channelId'] = this.channelId;
    data['is_unlike'] = this.isUnlike;
    return data;
  }
}
