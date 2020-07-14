import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallfy/data/function.dart';


class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String path;
  bool resizeCompleted = false;

  getDpr(){
    var dpr = MediaQuery.of(context).devicePixelRatio;
    return dpr.round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LinearProgressIndicator(),
              RaisedButton(
                child: Text("Resize"),
                onPressed: () async {
                print("resizing...");
                String path = (await getExternalStorageDirectory()).path+"/wallpaper.jpg";
                print(path);
                var result = await resizeImage(filePath: path);
                print(result);
//                await Future.delayed(Duration(milliseconds: 500));
                var wallres = await setWallpaperFromFile(location: 1);
                print(wallres);
                }
              ),
              resizeCompleted
                  ? Image.file(File(path))
                  : CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
