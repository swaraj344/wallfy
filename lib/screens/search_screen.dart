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
  int maxPage;
  int page = 1;
  bool loading = true;
  ScrollController _scrollController;

  List<WallpaperModel> wallpaper = new List();


  searchWallpaperQuery(String query, {page}) async {
    print("loading in search");
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
      searchWallpaperQuery(widget.searchQuery, page: page);
    } else {
      print("already loading $loading");
    }
  }

  @override
  void initState() {
    searchController.text = widget.searchQuery;
    searchWallpaperQuery(widget.searchQuery);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black54

        ),
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
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
