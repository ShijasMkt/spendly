import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject{

  @HiveField(0)
  String name;

  @HiveField(1)
  int iconCode;

  Category({
    required this.name,
    required this.iconCode
  });
}