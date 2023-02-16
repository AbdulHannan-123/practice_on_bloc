// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

//want to tell the bloc to load something to load instance

@immutable 
abstract class LoadAction {     // we define this as whole class so that we can change miltiple actons in a class
  const LoadAction();
}

@immutable
class LoadPersonUrl implements LoadAction {
  final PersonUrl url;
  const LoadPersonUrl({required this.url}) : super();
}


@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
    :name = json['name'] as String,
    age = json['age'] as int;
  
}

Future<Iterable<Person>> getPerson(String url) => HttpClient()
  .getUrl(Uri.parse(url))          // this give us request 
  .then((req) => req.close())     // this will make an request [close] and make a risponse
  .then((resp) => resp.transform(utf8.decoder).join())        // response goes here and becomes a string
  // String representation of that data
  .then((str) => json.decode(str) as List<dynamic>)          // string goes here and become a list
  .then((list) => list.map((e) => Person.fromJson(e)));      // list go here and becme iterable of persons  and the result is future





enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl{
  String get urlString{
    switch (this) {               // this identify the instance of PersonUrl
      case PersonUrl.person1:
          return 'http://127.0.0.1:5500/api/person1.json';
      case PersonUrl.person2:
          return 'http://127.0.0.1:5500/api/person2.json';
        
    }
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    late final Bloc myBloc;

    return Scaffold(
      appBar: AppBar(
        title:const Text('Bloc Cach concept'),
      ),
    );
  }
}
