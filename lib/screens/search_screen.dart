import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallfy/data/data.dart';
import 'package:wallfy/modal/wallpaper_model.dart';
import 'package:wallfy/widget/widget.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  SearchScreen({@required this.searchQuery});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = new TextEditingController();

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
    searchWallpaperQuery(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54

        ),
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(26.0)),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search",
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          wallpaper.clear();
                          searchWallpaperQuery(searchController.text);
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(height: 16.0,),
              wallpaperList(context: context, wallpaper: wallpaper)
            ],
          ),
        ),
      ),
    );
  }
}
