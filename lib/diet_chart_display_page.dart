import 'package:flutter/material.dart';

class DietChartDisplayPage extends StatelessWidget {
  const DietChartDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Diet Chart')),
      body: const Center(
        child: Text('This is where the generated diet chart will be displayed.'),
      ),
    );
  }
}