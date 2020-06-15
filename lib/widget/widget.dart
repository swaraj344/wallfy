import 'package:flutter/material.dart';
import 'package:wallfy/modal/wallpaper_model.dart';
import 'package:wallfy/screens/image_preview_screen.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(text: 'Wall', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 20.0)),
        TextSpan(text: 'fy',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 20.0)),
      ],
    ),
  );
}

Widget wallpaperList({List<WallpaperModel> wallpaper, BuildContext context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: GridView.count(

      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: wallpaper.map((wallpaper) {
        return GridTile(
          child: Container(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ImagePreview(wallpaper.urls.regular),
                ));
              },
              child: ClipRRect(
                  child: Image.network(
                wallpaper.urls.thumb,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16.0),),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
