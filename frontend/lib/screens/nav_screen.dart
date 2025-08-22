import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/custom_buttons.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final StorageService storageService = StorageService();
  String? token;
  bool isLoading = true;

  final screens = [
    HomeScreen(),
    Scaffold(
      body: Center(
        child: Text("Explore"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("Add"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("Subscriptions"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("Profile"),
      ),
    ),
  ];

  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final fetchedToken = await storageService.getToken() ?? "";
    setState(() {
      token = fetchedToken;
      log(token! + '-------------------------------------------------');
      isLoading = false;
    });
  }

  Future showLogOutBox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text(
          "Confirm",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Container(
          padding: const EdgeInsets.all(1.0),
          child: RichText(
            textWidthBasis: TextWidthBasis.longestLine,
            overflow: TextOverflow.fade,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Are you sre you want to logout?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        actions: [
          CustomElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: "No",
          ),
          CustomElevatedButton(
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              Get.find<AuthController>().logout().whenComplete(() {
                Get.offAll(LoginScreen());
              });
            },
            title: "Yes",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return token != null && token!.isEmpty
        ? LoginScreen()
        : Scaffold(
            appBar: AppBar(
              elevation: 3,
              title: Text("Youtube"),
              backgroundColor: Colors.white,
              shadowColor: Colors.black,
              toolbarHeight: 70,
              actions: [
                IconButton(
                  onPressed: () {
                    showLogOutBox(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 27,
                  ),
                )
              ],
            ),
            body: screens[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 4,
              currentIndex: selectedIndex,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  activeIcon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore',
                  activeIcon: Icon(Icons.explore),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outlined),
                  label: 'Add',
                  activeIcon: Icon(Icons.add_circle),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions_outlined),
                  label: 'Subscriptions',
                  activeIcon: Icon(Icons.subscriptions),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                  activeIcon: Icon(Icons.account_circle),
                ),
              ],
            ),
          );
  }
}
