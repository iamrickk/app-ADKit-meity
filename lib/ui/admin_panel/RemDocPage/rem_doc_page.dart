import 'package:flutter/material.dart';


class RemDocPage extends StatefulWidget {
  const RemDocPage({super.key});

  @override
  State<RemDocPage> createState() => _RemDocPageState();
}

class _RemDocPageState extends State<RemDocPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}