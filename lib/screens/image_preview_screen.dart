import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallfy/data/function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class ImagePreview extends StatefulWidget {
  final String imgPreviewUrl, imgUrl,fileName;
  ImagePreview({this.imgPreviewUrl, this.imgUrl,this.fileName});
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}



class _ImagePreviewState extends State<ImagePreview> {







  String initialPath;
  String newImgPath;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool isLoading = true;
  bool isDownloadComplete = false;
  int progress = 0;

  var downloadTaskId;


  Future<void> runOnStart() async {
    if (await checkPermission()) {
      initialPath = await downloadFile(url: widget.imgUrl);

    }
  }


  Future<String> downloadFile({@required String url}) async {
    String path = (await getApplicationDocumentsDirectory()).path;
    print(path);
    final taskId = await FlutterDownloader.enqueue(
        openFileFromNotification: false,
        showNotification: false,
        url: url,
        savedDir: path,
        fileName: "wallpaper.jpg");
    initialPath = path + "/wallpaper.jpg";
    downloadTaskId = taskId;
    return path + "/wallpaper.jpg";
  }

  _showBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Wrap(
              children: [
                Container(
//              color: Colors.red,
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 500));
                      print("try Setting wallpaper to lock");
                      if (!isLoading) {
                        var result = await setWallpaperFromFile(location: 2);
                        print(result);
                        showSnackBarMethod(message: "Wallpaper Set Success", scaffoldKey: scaffoldKey);
                        print("Wallpaper set Successful");
                      }
                    },
                    leading: Icon(Icons.screen_lock_portrait),
                    title: Text("Set as Lock screen"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 500));
                      if (!isLoading) {
                        print("try setting wallpaper to home");
                        var result = await setWallpaperFromFile(location: 1);
                        print(result);
                        showSnackBarMethod(message: "Wallpaper Set Success", scaffoldKey: scaffoldKey);
                        print("wallpaper set Success to home");
                      }
                    },
                    leading: Icon(Icons.home),
                    title: Text("Set as Home screen"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 500));
                      print("try setting wallpaper to Both");
                      await setWallpaperFromFile(location: 1);
                      await setWallpaperFromFile(location: 2);
                      print("wallpaper set Success to Both");
                    },
                    leading: Icon(Icons.wallpaper),
                    title: Text("Both"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      saveToGallery(filePath: initialPath, fileName: widget.fileName,scaffoldKey: scaffoldKey);
                    },
                    leading: Icon(Icons.cloud_download),
                    title: Text("Save To Gallery"),
                  ),
                )
              ],
            ),
          );
        });
  }


  ReceivePort _port = ReceivePort();

  @override
  initState() {
    runOnStart();

    super.initState();
    _bindBackgroundIsolate();
    _port.listen((dynamic data) async {
      DownloadTaskStatus status = data[1];
      progress = data[2];
      if(status.value == 3){
        isDownloadComplete = true;
        await Future.delayed(Duration(milliseconds: 200));
        resizeImage(filePath: initialPath).whenComplete(() {
          isLoading = false;
          setState(() {
          });
        });
//        resize(filePath: initialPath,height: MediaQuery.of(context).size.height.floor(),width: MediaQuery.of(context).size.width.floor()).then((value) {
//          newImgPath = value;
//          isLoading = false;
//          setState(() {
//
//          });
//          print("resize done at $newImgPath");
//        });
      }
      setState((){
        print("Progress: $progress");
        print("Status : ${status.value}");
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }
  void _bindBackgroundIsolate(){
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
int v;
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
                child: Image.network(widget.imgPreviewUrl,fit: BoxFit.cover),

                ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {

                        if (!isLoading) {
                          _showBottomSheet(context);
                        }

                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.black.withOpacity(0.3),
                              Colors.white.withOpacity(0.2)
                            ]),
                            borderRadius: BorderRadius.circular(26.0)),
                        child: isLoading
                            ? CircularProgressIndicator(value: progress/100,)
                            : Text(
                                "Set Wallpaper",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0),
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
            ),

          ],
        ));
  }
}
