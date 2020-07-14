import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ScrollController scrollController;
  TextEditingController searchController = new TextEditingController();
  List<CategoriesModal> categories = new List();
  List<WallpaperModel> wallpaper = new List();
  int page = 1;
  int maxPage;
  bool loading = true;

  Future loadListsOfWallpaper({page}) async {

    var apiUrl =
        'https://api.unsplash.com/search/photos?page=$page&query=hd wallpapers&orientation=portrait&per_page=30';

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

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                title: Center(
                    child: Icon(
                  Icons.signal_cellular_connected_no_internet_4_bar,
                  color: Colors.red,
                )),
                content: Text("Check your Connection"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text("Exit"),
                  )
                ],
              ),
            );
          });
    }
  }

  loadMore() {
    if (loading) {
      print("loading");
      loading = false;
      page = page + 1;
      loadListsOfWallpaper(page: page);
    } else {
      print("already loading $loading");
    }
  }

  checkInternet() {}

  @override
  void initState() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      var prePixel = 300.0;
      if (maxScroll - currentScroll <= prePixel) {
        if (page != maxPage + 1) {
          loadMore();
        }
      }
    });
    loadListsOfWallpaper();
    categories = getCategories();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
        physics: BouncingScrollPhysics(),
        controller: scrollController,
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
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    searchQuery: searchController.text,
                                  )));
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 80,
                child: ListView.builder(
//                  controller: scrollController,
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
              wallpaperList(wallpaper: wallpaper, context: context)
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriesScreen(
                      query: title.toLowerCase(),
                    )));
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(

                height: 60.0,
                width: 120.0,
                color: Colors.black26,
                alignment: Alignment.center,
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
