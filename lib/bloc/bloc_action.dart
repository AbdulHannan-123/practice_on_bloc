import 'package:flutter/foundation.dart' show immutable;
import 'package:practice_on_bloc_pattern/bloc/person.dart';



const person1Url = 'http://127.0.0.1:5500/api/person1.json';
const person2Url = 'http://127.0.0.1:5500/api/person2.json';



//want to tell the bloc to load something to load instance

@immutable 
abstract class LoadAction {     // we define this as whole class so that we can change miltiple actons in a class
  const LoadAction();
}

@immutable
class LoadPersonUrl implements LoadAction {
  final String url;
  final PersonsLoadeer loadeer; 
  const LoadPersonUrl({required this.url , required this.loadeer}) : super();
}

//let define type defination
//                       the iterable of persons    takes the url and return
typedef PersonsLoadeer = Future<Iterable<Person>> Function(String url);



// enum PersonUrl {
//   person1,
//   person2,
// }

// extension UrlString on PersonUrl{   // because its hard coded so we killed that part to make the dynamic version of it
//   String get urlString{
//     switch (this) {               // this identify the instance of PersonUrl
//       case PersonUrl.person1:
//           return 'http://127.0.0.1:5500/api/person1.json';
//       case PersonUrl.person2:
//           return 'http://127.0.0.1:5500/api/person2.json';
        
//     }
//   }
// }