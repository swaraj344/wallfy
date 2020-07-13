import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallfy/data/data.dart';
import 'package:wallfy/modal/wallpaper_model.dart';
import 'package:wallfy/widget/widget.dart';
import 'package:http/http.dart' as http;

class CategoriesScreen extends StatefulWidget {
  final String query;
  CategoriesScreen({this.query});
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<WallpaperModel> wallpaper = new List();
  ScrollController _scrollController;
  int page = 1;
  int maxPage;

  bool loading = true;

  searchWallpaperQuery(String query, {page}) async {
    var apiUrl =
        'https://api.unsplash.com/search/photos?page=$page&query=$query&orientation=portrait&per_page=30';
    try {
      var response = await http
          .get(apiUrl, headers: {'Authorization': 'Client-ID $apiKey'});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        jsonData["results"].forEach((jsonData) {
          WallpaperModel wallpaperModel = new WallpaperModel.fromMap(jsonData);
          wallpaper.add(wallpaperModel);
        });
        setState(() {});
        maxPage = jsonData['total_pages'];
        loading = true;
      }

    } catch (e) {
      print("Error : $e");
    }
  }

  loadMore() {
    if (loading) {
      print("loading");
      loading = false;
      page = page + 1;
      searchWallpaperQuery(widget.query, page: page);
    } else {
      print("already loading $loading");
    }
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      var prePixel = 300.0;
      if ( maxScroll - currentScroll <= prePixel) {
        if (page != maxPage + 1) {

          loadMore();
        }
      }
    });
    searchWallpaperQuery(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: brandName(),
        elevation: 0.0,
      ),
      body: wallpaperList(
          wallpaper: wallpaper,
          context: context,
          controller: _scrollController),
    );
  }
}
