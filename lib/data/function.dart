import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';



const MethodChannel _channel = const MethodChannel('com.swaraj344.wallfy/wallpaper');

Future<String> setWallpaperFromFile({@required int location}) async {
  final int result = await _channel.invokeMethod('setWallpaperFromFile',
      {'location': location});
  return result > 0 ? "Wallpaper set" : "There was an error.";
}

Future<String> resizeImage({@required String filePath}) async {
final int result = await _channel.invokeMethod("resizeImage",{'filePath':filePath});
return result > 0 ? "Image Resized" : "Failed to Resize image";
}


Future<bool> checkPermission() async {
  bool permission;
  var status = await Permission.storage.status;
  if (status == PermissionStatus.undetermined){
    var request = await Permission.storage.request();
    if (request == PermissionStatus.denied) {
      await checkPermission();
    }else if(request == PermissionStatus.granted){
      permission = true;
    }
    print(request);
  } else if (status == PermissionStatus.denied) {
    var request = await Permission.storage.request();
    if (request == PermissionStatus.denied) {
      await checkPermission();
    } else if (request == PermissionStatus.permanentlyDenied) {
      print("permission Permanentlydenied");
      permission = false;
    } else if(request == PermissionStatus.granted){
      permission = true;

    }
  }else if(status == PermissionStatus.granted){
    permission = true;
  }else if(status == PermissionStatus.permanentlyDenied){
    checkPermission();
    permission = false;
  }
  return permission;
}


void showSnackBarMethod(
    {@required message, @required GlobalKey<ScaffoldState> scaffoldKey,int duration=3}) {
  final snackBar = SnackBar(
    duration: Duration(seconds: duration),
    content: Text(message),
  );
  scaffoldKey.currentState.showSnackBar(snackBar);
}

saveToGallery({@required String filePath,@required String fileName,GlobalKey scaffoldKey}) async {

  File file = File(filePath);
  var path = (await getExternalStorageDirectory()).path;
  var newPath = path.split("Android");
  Directory dir = new Directory(newPath[0]+"Pictures/");
  if(await dir.exists()){
    print("Dir Already Exists");
  }else{
    dir = await dir.create();
    print("dir created");
  }
  var newFilePath = dir.path + "$fileName.jpg";
  file.copySync(newFilePath);
  showSnackBarMethod(message: "File Saved At :$newFilePath", scaffoldKey: scaffoldKey);
}

