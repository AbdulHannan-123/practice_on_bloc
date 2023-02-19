// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'bloc/bloc_action.dart';
import 'bloc/person.dart';
import 'bloc/person_bloc.dart';

extension Log on Object{
  void log()=> devtools.log(toString());
}

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
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: HomePage(),
        ),
    );
  }
}











Future<Iterable<Person>> getPerson(String url) => HttpClient()
  .getUrl(Uri.parse(url))          // this give us request 
  .then((req) => req.close())     // this will make an request [close] and make a risponse
  .then((resp) => resp.transform(utf8.decoder).join())        // response goes here and becomes a string
  // String representation of that data
  .then((str) => json.decode(str) as List<dynamic>)          // string goes here and become a list
  .then((list) => list.map((e) => Person.fromJson(e)));      // list go here and becme iterable of persons  and the result is future





// const List<String> names = ["foo","bar"];   // list it self is iterable

// void testIt(){
//   final baz = names[2];
// }

extension Subscript<T> on Iterable<T>{
  T? operator[](int index) => length > index ?elementAt(index) :null; 
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
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
              onPressed: (){
                 context.read<PersonBloc>().add(const 
                 LoadPersonUrl(
                  url: person1Url ,
                  loadeer: getPerson ,
                  ));     // because peson bloc req a load action
              }, 
              child: const Text("Load json 1"),
              ),


              TextButton(
              onPressed: (){
                context.read<PersonBloc>().add(
                  LoadPersonUrl(
                  url: person2Url ,
                  loadeer:getPerson ,
                  ),
                );
              }, 
              child: const Text("Load json 2"),
              ),
            ],
          ),
          BlocBuilder<PersonBloc , FetchResults?>(
            buildWhen: (previous, current) {      // it decide either you want to rebuild the builder or not by just true or false conditions 
              return previous?.persons != current?.persons;
            },
            builder: (context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if(persons == null){
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder:(context, index) {
                    final person = persons[index]!;
                    print(person.name);
                    return ListTile(
                      title: Text(person.name),
                      // subtitle: Text(person.age.toString()),
                    );   // it uses our subscript method above because its iterable
                  },
                ),
              );
            },
            ),
        ],
      ),
    );
  }
}
