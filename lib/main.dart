import 'package:flutter/material.dart';
import 'package:todo/pages/homepage.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/pages/product_page.dart';
import 'package:todo/pages/register_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/products': (context) => const ProductsPage(),
      },
    );
  }
}
