import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  Person({required this.token, required this.subnName});
  @HiveField(0)
  String subnName;

  @HiveField(1)
  int token;
}
