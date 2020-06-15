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


  searchWallpaperQuery(String query) async {
    var apiurl =
        'https://api.unsplash.com/search/photos?page=1&query=$query&orientation=portrait';
    var response =
    await http.get(apiurl, headers: {'Authorization': 'Client-ID $apiKey'});
    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["results"].forEach((jsonData) {
      WallpaperModel wallpaperModel = new WallpaperModel.fromMap(jsonData);
      wallpaper.add(wallpaperModel);
    });
    setState(() {});
  }
  @override
  void initState() {
    searchWallpaperQuery(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: brandName(),
        elevation: 0.0,
      ),
      body: wallpaperList(wallpaper: wallpaper,context: context),
    );
  }
}
