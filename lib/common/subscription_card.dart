// import 'package:flutter/material.dart';

// class RedditPremiumPage extends StatefulWidget {
//   @override
//   _RedditPremiumPageState createState() => _RedditPremiumPageState();
// }

// class _RedditPremiumPageState extends State<RedditPremiumPage> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscribe to Reddit Premium'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Choose a subscription plan:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             SubscriptionCard(
//               title: 'Monthly Plan',
//               price: '\$9.99',
//               duration: 'per month',
//               isSelected: _selectedIndex == 0,
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 0;
//                 });
//               },
//             ),
//             SizedBox(height: 16),
//             SubscriptionCard(
//               title: 'Yearly Plan',
//               price: '\$99.99',
//               duration: 'per year',
//               isSelected: _selectedIndex == 1,
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 1;
//                 });
//               },
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 // Perform subscription logic
//               },
//               child: Text('Subscribe'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SubscriptionCard extends StatelessWidget {
//   final String title;
//   final String price;
//   final String duration;
//   final bool isSelected;
//   final VoidCallback onTap;

//   SubscriptionCard({
//     required this.title,
//     required this.price,
//     required this.duration,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: isSelected ? Colors.orange : Colors.white,
//         elevation: isSelected ? 4.0 : 2.0,
//         shape: isSelected
//             ? RoundedRectangleBorder(
//                 side: BorderSide(
//                   color: Colors.orange,
//                   width: 2.0,
//                 ),
//                 borderRadius: BorderRadius.circular(8.0),
//               )
//             : null,
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Price: $price',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 duration,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
