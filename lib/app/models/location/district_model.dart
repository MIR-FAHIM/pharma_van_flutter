import 'dart:convert';

DistrictResponse districtResponseFromJson(String str) =>
    DistrictResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String districtResponseToJson(DistrictResponse data) =>
    json.encode(data.toJson());

class DistrictResponse {
  final String? status;
  final String? message;
  final List<DistrictModel> data;

  const DistrictResponse({
    this.status,
    this.message,
    required this.data,
  });

  factory DistrictResponse.fromJson(Map<String, dynamic> json) =>
      DistrictResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        data: json['data'] is List
            ? (json['data'] as List)
                .map((item) => DistrictModel.fromJson(
                      Map<String, dynamic>.from(item as Map),
                    ))
                .toList()
            : <DistrictModel>[],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };
}

class DistrictModel {
  final int? id;
  final int? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;

  const DistrictModel({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: _asInt(json['id']),
        divisionId: _asInt(json['division_id']),
        name: json['name']?.toString(),
        bnName: json['bn_name']?.toString(),
        lat: json['lat']?.toString(),
        lon: json['lon']?.toString(),
        url: json['url']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'division_id': divisionId,
        'name': name,
        'bn_name': bnName,
        'lat': lat,
        'lon': lon,
        'url': url,
      };
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
