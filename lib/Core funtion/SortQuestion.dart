import 'package:flutter/material.dart';

class SortQuestion extends StatefulWidget {
  final List<String> items;
  final List<String> initialItems;
  final String convertItem;
  final String question;
  final String Id;

  SortQuestion({
    required this.items,
    required this.initialItems,
    required this.convertItem,
    required this.question,
    required this.Id,
  });

  @override
  _SortQuestionState createState() => _SortQuestionState();
}

class _SortQuestionState extends State<SortQuestion> {
  late List<String> items;
  late List<String> sortedItems;
  late List<String> initialItems;
  late String convertItem;
  late String question;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    initialItems = widget.initialItems;
    convertItem = widget.convertItem;
    question = widget.question;
    sortedItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestion(),
              SizedBox(height: 10),
              _buildSortedItemsContainer(),
              SizedBox(height: 10),
              _buildResetIcon(),
              SizedBox(height: 10),
              _buildDraggableItems(),
              SizedBox(height: 10),
              _buildDragTarget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _resetItems() {
    setState(() {
      items = List.from(initialItems);
      sortedItems.clear();
    });
  }

  Widget _buildSortedItemsContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth * 0.9;
        return Container(
          width: containerWidth,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sortedItems.isEmpty
                  ? [Text('Drop items here', style: TextStyle(fontSize: 18))]
                  : sortedItems.map((item) {
                final isFull = sortedItems.length == 4;
                final isCorrect = isFull && sortedItems.join(' ') == convertItem;
                return Container(
                  height: 40,
                  width: containerWidth * 0.8,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isFull
                        ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.refresh, color: Colors.blue, size: 30),
        onPressed: _resetItems,
      ),
    );
  }

  Widget _buildDraggableItems() {
    return Column(
      children: items.map((item) {
        return Draggable<String>(
          data: item,
          child: _buildDragItem(item, Colors.blue.shade200),
          feedback: Material(
            child: _buildDragItem(item, Colors.blue),
          ),
          childWhenDragging: _buildDragItem(item, Colors.blue.shade50),
          onDragCompleted: () {},
          onDraggableCanceled: (velocity, offset) {},
        );
      }).toList(),
    );
  }

  Widget _buildDragTarget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth * 0.9;

        return Container(
          width: containerWidth,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade400),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade50,
          ),
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Center(
                child: Text('Drop here to sort'),
              );
            },
            onAccept: (data) {
              setState(() {
                sortedItems.add(data);
                items.remove(data);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildDragItem(String item, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
