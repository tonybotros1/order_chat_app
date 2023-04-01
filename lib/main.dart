import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orders_chat_app/screens/main_screens/vendor_screen.dart';
import 'screens/auth_screens/loading_screen.dart';
import 'screens/auth_screens/register_screen22222222.dart';
import 'screens/main_screens/customer_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const LoadingScreen(),
      getPages: [
        GetPage(name: '/Vendor', page: () => VendorScreen()),
        GetPage(name: '/Customer', page: () => CustomerScreen()),
      ],
    );
  }
}




// implementation 'com.google.android.play:integrity:1.1.0'
//     implementation 'com.google.firebase:firebase-appcheck-safetynet:16.1.2'
//     implementation 'androidx.browser:browser:1.2.0' 