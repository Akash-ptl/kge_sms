// import 'package:flutter/material.dart';
// import 'package:sim_data/sim_model.dart';
//
// import 'messages.dart';
//
// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key, required this.simCard});
//
//   final List<SimCard> simCard;
//
//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }
//
// class _NavigationScreenState extends State<NavigationScreen> {
//   int _currentIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: null,
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           // MyHomePage(
//           //   simCard: widget.simCard,
//           // ),
//           MessageList(
//             simCard: widget.simCard,
//           ),
//           const SizedBox(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//         items: [
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.send,
//           //       color: _currentIndex == 0 ? Colors.blue : Colors.grey),
//           //   label: 'Send',
//           // ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message,
//                 color: _currentIndex == 0 ? Colors.blue : Colors.grey),
//             label: 'Messages',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person,
//                 color: _currentIndex == 1 ? Colors.blue : Colors.grey),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }
// }
