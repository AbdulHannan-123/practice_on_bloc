import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'bloc_action.dart';
import 'person.dart';

class PersonBloc extends Bloc<LoadAction,FetchResults?>{
  // PersonBloc() : super(null);
  final Map<String, Iterable<Person>> _cache = {};
  PersonBloc() : super(null){
    on<LoadPersonUrl>((event, emit) async {      //event is the input of bloc andemit is output
        final url = event.url;
        if (_cache.containsKey(url)) {
          //we know that we hve the value in cache
          final cachePersons = _cache[url]!;
          final result = FetchResults(persons: cachePersons, isRetrivedFromCache: true);

          emit(result);
          
        }else{
          final loader = event.loadeer;
          final person = await loader(url);
          _cache[url] = person;
          final result = FetchResults(persons: person, isRetrivedFromCache: false);
          emit(result); 
        }
    });
  }

}







extension IsEqualToIgnoringOrdering<T> on Iterable<T>{
  bool isEqualToIgnoringOrdering(Iterable<T> other) => 
  length == other.length && 
  {...this}.intersection({...other}).length == length;
}


@immutable     // State
class FetchResults {
  final Iterable<Person> persons;
  final bool isRetrivedFromCache;     // to make sure that we wouldn't recll the api after fatches the results

  const FetchResults({
    required this.persons,
    required this.isRetrivedFromCache,
  });

  @override
  String toString() => 'FetchResultsc (isRetrivedFromCache =$isRetrivedFromCache , persons = $persons)';

  @override
  bool operator == (covariant FetchResults other) =>                   // as we implement the equality so we need to put the hashcode as well
   persons.isEqualToIgnoringOrdering(other.persons) && 
   isRetrivedFromCache == other.isRetrivedFromCache ;


   @override
  int get hashCode => Object.hash(persons, isRetrivedFromCache,);

}
















