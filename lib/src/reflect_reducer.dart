import 'reflect_builder.dart';

class ReflectReducer<T, K> {
  String name;
  ReflectBuilder<T, K> builder;

  ReflectReducer({this.name, this.builder});
}