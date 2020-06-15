import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallfy/data/data.dart';
import 'package:wallfy/modal/modal.dart';
import 'package:wallfy/modal/wallpaper_model.dart';
import 'package:wallfy/screens/categoriesScreen.dart';
import 'package:wallfy/screens/search_screen.dart';
import 'package:wallfy/widget/widget.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<CategoriesModal> categories = new List();
  List<WallpaperModel> wallpaper = new List();

  loadListsOfWallpaper() async {
    var apiurl =
        'https://api.unsplash.com/search/photos?page=1&query=wallpaper&orientation=portrait';
    var response =
        await http.get(apiurl, headers: {'Authorization': 'Client-ID $apiKey'});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["results"].forEach((jsonData) {
      WallpaperModel wallpaperModel = new WallpaperModel.fromMap(jsonData);
      wallpaper.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    loadListsOfWallpaper();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> SearchScreen(searchQuery: searchController.text,)
                          ));
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 80,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoriesCard(
                          title: categories[index].categoriesName,
                          imgUrl: categories[index].imgUrl);
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              wallpaperList(context: context, wallpaper: wallpaper)
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {
  final String imgUrl, title;

  CategoriesCard({@required this.imgUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen(query: title.toLowerCase(),)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imgUrl,
                  height: 60.0,
                  width: 120.0,
                  fit: BoxFit.cover,
                )),
            Container(
              height: 60.0,
              width: 120.0,
              color: Colors.black26,
              alignment: Alignment.center,
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}
