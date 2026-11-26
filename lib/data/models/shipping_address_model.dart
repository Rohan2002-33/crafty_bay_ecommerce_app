import '../../core/utils/json_helper.dart';

class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
  });

  final String fullName;
  final String address;
  final String city;
  final String postalCode;
  final String phone;

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'address': address,
        'city': city,
        'postal_code': postalCode,
        'phone': phone,
      };

  factory ShippingAddress.fromJson(Map<String, dynamic> j) => ShippingAddress(
        fullName: Json.str(j['full_name']),
        address: Json.str(j['address']),
        city: Json.str(j['city']),
        postalCode: Json.str(j['postal_code']),
        phone: Json.str(j['phone']),
      );
}