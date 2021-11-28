import 'package:firebase/screens/products_add_screen.dart';
import 'package:firebase/screens/products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/addProducts': (BuildContext context) => ProductsAddScreen(),
        '/home': (BuildContext context) => Home(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de productos'),
        actions: [],
        backgroundColor: Color.fromRGBO(196, 91, 80, 1),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(196, 91, 80, 1),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductsAddScreen()));
        },
      ),
      body: ListProducts(),
    );
  }
}
