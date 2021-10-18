import 'package:flutter/material.dart';
import 'package:load/load.dart';

/**
 * FOR THE LOVE OF GOD, DO NOT CALL THIS WIDGET LoadingScreen() OR IT BREAKS EVERYTHING
 */
class ShowLoadOverWholeScreen extends StatefulWidget {
  const ShowLoadOverWholeScreen({Key? key}) : super(key: key);

  @override
  _ShowLoadOverWholeScreenState createState() =>
      _ShowLoadOverWholeScreenState();
}

class _ShowLoadOverWholeScreenState extends State<ShowLoadOverWholeScreen> {
  @override
  void initState() {
    super.initState();
    // Show loading once, after widget has loaded. May not be necessary.
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        showLoadingDialog(); //MAybe the problem was I was calling this inside the provider AND inside the loading screen??
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
