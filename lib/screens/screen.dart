import 'package:cemana/screens/screen_desktop.dart';
import 'package:cemana/screens/screen_mobile.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.id, {super.key});

  final String? id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size!;
    double width = size.width;
    double height = size.height;
    if ((height >= 768 && width >= 768)) {
      return ScreenDesktop(widget.id);
    }
    return ScreenMobile(widget.id);
  }
}
