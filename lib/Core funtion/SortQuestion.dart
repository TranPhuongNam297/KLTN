// import 'package:flutter/material.dart';
//
// class SortQuestion extends StatefulWidget {
//   @override
//   _SortQuestionState createState() => _SortQuestionState();
// }
//
// class _SortQuestionState extends State<SortQuestion> {
//   List<String> initialItems = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
//   List<String> items = [];
//   List<String> sortedItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     items = List.from(initialItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SortQuestion'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Chỗ xuất hiện câu hỏi', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             _buildSortedItemsContainer(),
//             SizedBox(height: 20),
//             _buildDraggableItems(),
//             SizedBox(height: 20),
//             _buildDragTarget(),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _resetItems,
//               child: Text('Reset Items'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _resetItems() {
//     setState(() {
//       items = List.from(initialItems);
//       sortedItems.clear();
//     });
//   }
//
//   Widget _buildSortedItemsContainer() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final containerWidth = screenWidth * 0.9;
//
//         return Container(
//           width: containerWidth,
//           height: 200, // Chiều cao cố định
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: sortedItems.isEmpty
//                   ? [Text('Drop items here', style: TextStyle(fontSize: 18))]
//                   : sortedItems.map((item) => LongPressDraggable<String>(
//                 data: item,
//                 child: DragTarget<String>(
//                   builder: (context, candidateData, rejectedData) {
//                     return Container(
//                       height: 40,
//                       width: containerWidth * 0.8, // Giới hạn chiều rộng
//                       alignment: Alignment.center,
//                       child: Text(item),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(color: Colors.black),
//                         ),
//                       ),
//                     );
//                   },
//                   onWillAccept: (data) {
//                     return true;
//                   },
//                   onAccept: (data) {
//                     setState(() {
//                       // Find the index of the item being replaced
//                       int index = sortedItems.indexOf(item);
//                       // Replace the item
//                       sortedItems[index] = data;
//                       // Add the replaced item back to the draggable items
//                       items.add(item);
//                       // Remove the item that was dragged from the draggable items
//                       items.remove(data);
//                     });
//                   },
//                 ),
//                 feedback: Material(
//                   child: _buildDragItem(item, Colors.grey),
//                 ),
//                 childWhenDragging: Container(
//                   height: 40,
//                   width: containerWidth * 0.8, // Giới hạn chiều rộng
//                   alignment: Alignment.center,
//                   child: Text(''),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 onDragCompleted: () {
//                   setState(() {
//                     sortedItems.remove(item);
//                   });
//                 },
//                 onDraggableCanceled: (velocity, offset) {
//                   setState(() {
//                     if (!sortedItems.contains(item)) {
//                       sortedItems.add(item);
//                     }
//                   });
//                 },
//               )).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   Widget _buildDraggableItems() {
//     return Column(
//       children: items.map((item) {
//         return Draggable<String>(
//           data: item,
//           child: _buildDragItem(item, Colors.grey.shade400),
//           feedback: Material(
//             child: _buildDragItem(item, Colors.grey),
//           ),
//           childWhenDragging: _buildDragItem(item, Colors.grey.shade200),
//           onDragCompleted: () {
//             setState(() {
//               // Do nothing on drag completed
//             });
//           },
//           onDraggableCanceled: (velocity, offset) {
//             setState(() {
//               // Do nothing on drag canceled
//             });
//           },
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildDragTarget() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final screenHeight = MediaQuery.of(context).size.height;
//         final containerWidth = screenWidth * 0.9;
//         final containerHeight = screenHeight * 0.1;
//
//         return Container(
//           width: containerWidth,
//           height: containerHeight,
//           color: Colors.grey.shade200,
//           child: DragTarget<String>(
//             builder: (context, candidateData, rejectedData) {
//               return Center(
//                 child: Text('Drop here to sort'),
//               );
//             },
//             onAccept: (data) {
//               setState(() {
//                 sortedItems.add(data);
//                 items.remove(data);
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDragItem(String item, Color color) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       padding: EdgeInsets.all(8),
//       color: color,
//       child: Center(
//         child: Text(item, style: TextStyle(fontSize: 16)),
//       ),
//     );
//   }
// }
