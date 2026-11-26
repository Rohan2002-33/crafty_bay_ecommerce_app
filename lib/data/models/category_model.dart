import '../../core/utils/json_helper.dart';

class CategoryModel {
  const CategoryModel({required this.id, required this.title, this.icon = ''});

  final String id;
  final String title;
  final String icon;

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
        id: Json.id(j),
        title: Json.str(j['title'], 'Category'),
        icon: Json.str(j['icon']),
      );
}