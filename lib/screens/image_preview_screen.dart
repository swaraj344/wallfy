import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final String imgUrl;
  ImagePreview(this.imgUrl);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.black.withOpacity(0.2),
                              Colors.white.withOpacity(0.2)
                            ]),
                            borderRadius: BorderRadius.circular(26.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Set Wallpaper",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0),
                            ),
                            Text(
                              "Save Wallpaper To Galery",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          alignment: Alignment.center,
//                    color: Colors.red,
                          height: 30,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue),
                          )),
                    ),
                    SizedBox(
                      height: 30.0,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
