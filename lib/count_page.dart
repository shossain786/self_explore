// count_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int targetCount = 50;

class CountPage extends StatefulWidget {
  final String itemName;

  const CountPage({super.key, required this.itemName});

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  int count = 0;

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
          print('Tapped: $count and Target: $targetCount');
          print('hello world------------------');
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
              Text('Target Count: $count'),
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        count = prefs.getInt('${widget.itemName}_count') ?? 0;
        // targetCount = prefs.getInt('${widget.itemName}_targetCount') ?? 0;
        // String targetKey = '${widget.itemName}_targetCount';
        String targetKey = 'galaxy123_targetCount';

        print('Looking for the key: $targetKey');

        for (String key in prefs.getKeys()) {
          print("Key: $key Data: ${prefs.get(key)}");
          print(prefs.getKeys().length);
          if (key.contains(targetKey)) {
            print('inside for.....');
            targetCount = prefs.getInt('galaxy123_targetCount') ?? 100;
          }
        }
      },
    );
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
