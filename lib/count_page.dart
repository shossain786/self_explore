// count_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountPage extends StatefulWidget {
  final String itemName;

  const CountPage({super.key, required this.itemName});

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  int count = 0;
  int targetCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasbih - ${widget.itemName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              _resetCount();
            },
          ),
        ],
      ),
      body: InkWell(
        onTap: () {
          _incrementCount();
          // print('Tapped: $count and Target: $targetCount');
          if (count == targetCount) {
            _showContinuePrompt();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Count: $count',
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              Text('Target Count: $targetCount'),
              Image.asset('assets/counter_pic.gif',
                  width: 400, height: 500), // Replace with your image path
            ],
          ),
        ),
      ),
    );
  }

  void _incrementCount() {
    setState(() {
      count++;
      _saveCount();
      if (count == targetCount) {
        _showContinuePrompt();
      }
    });
  }

  void _resetCount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Count'),
          content: const Text('Are you sure you want to reset the count?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  count = 0;
                });
                await _saveCount();
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = prefs.getInt('${widget.itemName}_count') ?? 0;
      targetCount = prefs.getInt('${widget.itemName}_targetCount') ?? 10;
    });
    // print('Loaded Count: $count');
    // print('Loaded Target Count: $targetCount');
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.itemName}_count', count);
    prefs.setInt('${widget.itemName}_targetCount', targetCount);
  }

  Future<void> _showContinuePrompt() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Target Reached'),
          content: const Text(
              'You have reached the target count. Do you want to continue counting?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _resetCount(); // Reset the count and continue counting
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
