import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'data/moor_database.dart';
import 'package:provider/provider.dart';

void main()=>runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=>AppDatabase().taskDao,
      child: const MaterialApp(
        title: 'Material App',
        home: HomePage(),
      ),
    );
  }
}

