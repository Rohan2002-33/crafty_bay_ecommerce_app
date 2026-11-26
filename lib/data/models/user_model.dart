import '../../core/utils/json_helper.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    this.city = '',
    this.address = '',
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String address;

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    final value = '$f$l'.toUpperCase();
    return value.isEmpty ? 'U' : value;
  }

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: Json.id(j),
        firstName: Json.str(j['first_name']),
        lastName: Json.str(j['last_name']),
        email: Json.str(j['email']),
        phone: Json.str(j['phone']),
        city: Json.str(j['city']),
        address: Json.str(j['address']),
      );
}