import 'package:flutter/material.dart';

class Writing extends StatefulWidget {
  const Writing({super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing'),
      ),
      body: Placeholder(),
    );
  }
}