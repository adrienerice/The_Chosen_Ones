import 'package:flutter/material.dart';
import 'package:load/load.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Show loading once, after widget has loaded. May not be necessary.
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        showLoadingDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      themeData: LoadingThemeData(),
      child: MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );
  }
}
