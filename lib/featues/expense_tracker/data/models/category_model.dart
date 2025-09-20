import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Icon icon;

  Category({
    required this.id,
    required this.name,
    required this.icon
  });
}