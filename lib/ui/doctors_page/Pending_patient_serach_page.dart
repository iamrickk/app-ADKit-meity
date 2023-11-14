// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class StyledSearchPage extends StatefulWidget {
//   @override
//   _StyledSearchPageState createState() => _StyledSearchPageState();
// }

// class _StyledSearchPageState extends State<StyledSearchPage> {
//   late String searchText = '';
//   late Future<List<QueryDocumentSnapshot?>> searchResults;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Styled Search Page'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter Full Name...',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   searchText = value;
//                 });
//               },
//               onSubmitted: (value) {
//                 performSearch();
//               },
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: FutureBuilder<List<QueryDocumentSnapshot?>>(
//                 future: searchResults,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text('No results found.'),
//                     );
//                   } else {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         var data = snapshot.data![index]!.data();
//                         // Customize how you want to display the search results
//                         return ListTile(
//                           title: Text(data!['name']),
//                           subtitle: Text(data!['email']),
//                           // Add more widgets as needed
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void performSearch() {
//     String searchLower = searchText.toLowerCase();
//     searchResults = FirebaseFirestore.instance
//         .collection('your_collection') // Replace with your collection name
//         .where('name_lower', isEqualTo: searchLower)
//         .get()
//         .then((snapshot) {
//       return snapshot.docs;
//     });
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: StyledSearchPage(),
//   ));
// }
