import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  String uName;

  User({
    required this.id,
    required this.uName
  });
}