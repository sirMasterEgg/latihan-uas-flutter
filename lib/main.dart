import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihanuas/config/sqllite_config.dart';
import 'package:latihanuas/firebase_options.dart';
import 'package:latihanuas/provider/catatan_provider.dart';
import 'package:latihanuas/ui/add_page.dart';
import 'package:latihanuas/ui/home_page.dart';
import 'package:latihanuas/ui/login_page.dart';
import 'package:latihanuas/ui/register_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqliteConfig().initDB();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CatatanProvider(),
      child: MaterialApp(
        title: 'Catatan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          HomePage.routeName: (context) => const HomePage(),
          AddPage.routeName: (context) => const AddPage(),
        },
      ),
    );
  }
}
