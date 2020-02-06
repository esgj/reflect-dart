import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'reflect_action.dart';
import 'reflect_reducer.dart';

class Reflect with ChangeNotifier {
  List<dynamic> reducers;
  ListQueue<String> _stateHistory;
  Map<String, dynamic> _state;

  Reflect.createState({this.reducers}) {
    _state = Map();
    _stateHistory = ListQueue();
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
  }

  void dispatchAction({ReflectAction action}) {
    _stateHistory.add(json.encode(_state, toEncodable: (dynamic value) {
      if (value is DateTime) {
        return value.toIso8601String();
      } else {
        return value;
      }
    }));
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder(_state[reducer.name], action));
    notifyListeners();
  }

  void addReducer(ReflectReducer reducer) => reducers.add(reducer);

  void rollback() {
    if (_stateHistory.length > 0) {
      _state = json.decode(_stateHistory.removeLast()) as Map<String, dynamic>;
      notifyListeners();
    }
  }

  Map<String, dynamic> get state => Map.from(_state);
  ListQueue<String> get stateHistory => _stateHistory;
}