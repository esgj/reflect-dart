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

  bool rollback() {
    if (_stateHistory.length > 0) {
      _state = _stateHistory.removeLast();
      notifyListeners();
      return true;
    }

    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
    return false;
  }

  Map<String, dynamic> get state => _state;
}