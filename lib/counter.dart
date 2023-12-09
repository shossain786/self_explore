// new_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'count_page.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<Map<String, dynamic>?> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _addItem();
            },
            child: const Text('Add Item'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]?['text']),
                  subtitle:
                      Text('Target Count: ${items[index]?['targetCount']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeItem(index);
                    },
                  ),
                  onTap: () {
                    _navigateToCountPage(items[index]?['text']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newItem = ''; // Variable to store the newly added item
        int targetCount = 0; // Variable to store the target count

        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  newItem = value; // Update the value as the user types
                },
                decoration: const InputDecoration(labelText: 'Item Text'),
              ),
              TextField(
                onChanged: (value) {
                  targetCount = int.tryParse(value) ??
                      0; // Parse target count as an integer
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Count'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newItem.isNotEmpty) {
                  // Add the item and target count to the list, save it, and close the dialog
                  setState(() {
                    items.add({'text': newItem, 'targetCount': targetCount});
                  });
                  await _saveItems();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCountPage(String itemName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountPage(itemName: itemName),
      ),
    );
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Remove the item from the list, save it, and close the dialog
                setState(() {
                  items.removeAt(index);
                });
                await _saveItems();
                Navigator.pop(context);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsList = prefs.getStringList('items') ?? [];

      setState(() {
        items = itemsList
            .map((item) {
              try {
                Map<String, dynamic> itemMap =
                    json.decode(item); // Convert JSON string to Map
                return itemMap;
              } catch (e) {
                print("Error decoding item: $e");
                return null; // Handle decoding errors gracefully
              }
            })
            .where((item) => item != null)
            .toList();
      });
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsList = items
        .map((item) => json.encode(item))
        .toList(); // Convert Map to JSON string
    prefs.setStringList('items', itemsList);
  }
}
