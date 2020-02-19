import 'package:flutter/material.dart';

import 'reflect_action.dart';
import 'reflect_reducer.dart';

class Reflect<T> with ChangeNotifier {
  List<ReflectReducer<dynamic, T>> reducers;
  Map<String, dynamic> _state;

  /// Creates a [Reflect<T>] ([T] is the enum action type) object which state is determined by calling every [ReflectReducer<dynamic, T>] builder.
  /// Must be given a list of [ReflectReducer<dynamic, T>]
  Reflect.createState({this.reducers}) : assert(reducers != null) {
    _state = Map();
    reducers.forEach((reducer) => _state[reducer.name] = reducer.builder());
  }

  /// Dispatch a [ReflectAction<T>] and rebuild state by calling every [ReflectReducer<dynamic, T>] builder with the current state.
  void dispatchAction({ReflectAction<T> action}) {
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder(_state[reducer.name], action));
    notifyListeners();
  }

  /// Add reducer [ReflectReducer<dynamic, T>] after initial build.
  void addReducer(ReflectReducer<dynamic, T> reducer) => reducers.add(reducer);

  /// Get current state, DO NOT change the state as it should work as a immutable object.
  /// If one mutates the state directly the app might crash and result in unexpected behaviour.
  Map<String, dynamic> get state => Map.from(_state);
}