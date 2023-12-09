// count_page.dart

import 'package:flutter/material.dart';

class CountPage extends StatelessWidget {
  final String itemName;

  const CountPage({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Count Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Item: $itemName'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement count logic here
              },
              child: const Text('Count'),
            ),
          ],
        ),
      ),
    );
  }
}
