import 'package:flutter/material.dart';

class ConnectivityErrorScreen extends StatelessWidget {
  const ConnectivityErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("No Internet connection!! Please try again later."),
    );
  }
}
