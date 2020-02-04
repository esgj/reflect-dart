import 'dart:collection';

import 'package:flutter/material.dart';

import 'reflect_action.dart';
import 'reflect_reducer.dart';

class Reflect with ChangeNotifier {
  List<dynamic> reducers;
  ListQueue<Map<String, dynamic>> _stateHistory;
  Map<String, dynamic> _state;

  Reflect.createState({this.reducers}) {
    _state = Map();
    _stateHistory = ListQueue();
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
  }

  void dispatchAction({ReflectAction action}) {
    _stateHistory.add(_state);
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder(_state[reducer.name], action));
    notifyListeners();
  }

  void addReducer(ReflectReducer reducer) => reducers.add(reducer);

  void rollback() {
    print(_stateHistory);
    print(_state);
    _state = _stateHistory.removeLast();

    notifyListeners();
  }

  Map<String, dynamic> get state => _state;
}