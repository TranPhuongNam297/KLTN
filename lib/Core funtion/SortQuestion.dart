import 'package:flutter/material.dart';

class SortQuestion extends StatefulWidget {
  final List<String> items;
  final List<String> correctAnswer;
  final Function(List<String>) onSorted;

  SortQuestion({
    required this.items,
    required this.correctAnswer,
    required this.onSorted,
  });

  @override
  _SortQuestionState createState() => _SortQuestionState();
}

class _SortQuestionState extends State<SortQuestion> {
  late List<String> _currentItems;

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(widget.items); // Copy initial items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort the Items'),
      ),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final String item = _currentItems.removeAt(oldIndex);
            _currentItems.insert(newIndex, item);
          });
        },
        children: _currentItems.map((item) {
          return ListTile(
            key: Key(item),
            title: Text(item),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onSorted(_currentItems);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
