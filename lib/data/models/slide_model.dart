import '../../core/utils/json_helper.dart';

class SlideModel {
  const SlideModel({
    required this.id,
    required this.photoUrl,
    this.description = '',
  });

  final String id;
  final String photoUrl;
  final String description;

  factory SlideModel.fromJson(Map<String, dynamic> j) => SlideModel(
        id: Json.id(j),
        photoUrl: Json.str(j['photo_url']),
        description: Json.str(j['description']),
      );
}