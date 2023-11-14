import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:thefirstone/ui/admin_panel/DashboardPage/dashboard_page.dart';
import 'package:thefirstone/ui/admin_panel/RemDocPage/rem_doc_page.dart';
import 'package:thefirstone/ui/admin_panel/VerifiedDocPage/verified_doc_page.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const RemDocPage(),
    const VerifiedDocPage()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // Adjust the radius as needed
              topRight: Radius.circular(20.0), // Adjust the radius as needed
            ),
            color: Colors.black, // Specify your desired background color
          ),
          // color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(17),
              gap: 5,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                // elements in the bottom Nav Bar
                GButton(
                  icon: Icons.home,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: CupertinoIcons.question_circle,
                  text: 'Unverified',
                ),
                GButton(
                  icon: CupertinoIcons.checkmark_alt_circle,
                  text: 'Verified',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
