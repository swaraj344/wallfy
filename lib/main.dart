import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:wallfy/screens/demo.dart';
import 'package:wallfy/screens/home_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: false);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
