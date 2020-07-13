import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallfy/modal/wallpaper_model.dart';
import 'package:wallfy/screens/image_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:image/image.dart' as IMG;

Widget brandName() {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
            text: 'Wall',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 20.0)),
        TextSpan(
            text: 'fy',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 20.0)),
      ],
    ),
  );
}

Widget wallpaperList(
    {List<WallpaperModel> wallpaper,
    BuildContext context,
    ScrollController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: GridView.count(
      controller: controller,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: wallpaper.map((wallpaper) {
        return gridTile(context, wallpaper);
      }).toList(),
    ),
  );
}

Widget gridTile(BuildContext context, WallpaperModel wallpaper) {
  return GridTile(
    child: Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePreview(
                    imgPreviewUrl: wallpaper.urls.small,
                    imgUrl: wallpaper.urls.custom,fileName: wallpaper.photoId,),
              ));
        },
        child: ClipRRect(
          child: Image.network(
            wallpaper.urls.thumb,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );
}




