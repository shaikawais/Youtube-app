import 'package:flutter/material.dart';
import 'package:frontend/screens/nav_screen.dart';
import 'package:frontend/utils/controller_bindings.dart';
import 'package:frontend/widgets/dismissable_keyboard.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(
    OverlaySupport.global(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      key: UniqueKey(),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedItemColor: Colors.black),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        initialBinding: InitialBindings(),
        getPages: [
          GetPage(
            name: '/',
            page: () => NavScreen(),
            binding: InitialBindings(),
          ),
        ],
      ),
    );
  }
}
