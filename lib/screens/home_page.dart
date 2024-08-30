import 'package:client_management_app/screens/client/client_list_page.dart';
import 'package:client_management_app/screens/lawyer/lawyer_list_page.dart';
import 'package:client_management_app/screens/project/project_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen height minus AppBar height and status bar height
    final screenHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/law_firm_logo_png.png',
                height: 40), // Replace with your logo
            const SizedBox(width: 10),
            const Text('Law Firm Management Software'),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
                child: Text('Welcome, User', style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child:
                Center(child: Text('Logout', style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_copy_rounded),
              title: const Text('Projects'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProjectListPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Clients'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ClientListPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Lawyers'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LawyerListPage()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context)
              .size
              .width, // Set width to the full width of the device
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/law-firm-blind-lady-justice-picjumbo-com.jpg'),
              fit: BoxFit
                  .cover, // This will cover the area of the screen available
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Our Software',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Our Law Firm Management Software is designed to streamline your legal practice.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                // Additional content...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
