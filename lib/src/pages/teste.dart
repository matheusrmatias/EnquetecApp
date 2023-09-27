import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestePage extends StatefulWidget {
  WebViewController web;
  TestePage({super.key, required this.web});

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: widget.web);
  }
}
