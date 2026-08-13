import 'dart:convert';

UpazilaResponse upazilaResponseFromJson(String str) =>
    UpazilaResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String upazilaResponseToJson(UpazilaResponse data) =>
    json.encode(data.toJson());

class UpazilaResponse {
  final String? status;
  final String? message;
  final List<UpazilaModel> data;

  const UpazilaResponse({
    this.status,
    this.message,
    required this.data,
  });

  factory UpazilaResponse.fromJson(Map<String, dynamic> json) =>
      UpazilaResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        data: json['data'] is List
            ? (json['data'] as List)
                .map((item) => UpazilaModel.fromJson(
                      Map<String, dynamic>.from(item as Map),
                    ))
                .toList()
            : <UpazilaModel>[],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };
}

class UpazilaModel {
  final int? id;
  final int? districtId;
  final String? name;
  final String? bnName;
  final String? url;

  const UpazilaModel({
    this.id,
    this.districtId,
    this.name,
    this.bnName,
    this.url,
  });

  factory UpazilaModel.fromJson(Map<String, dynamic> json) => UpazilaModel(
        id: _asInt(json['id']),
        districtId: _asInt(json['district_id']),
        name: json['name']?.toString(),
        bnName: json['bn_name']?.toString(),
        url: json['url']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'district_id': districtId,
        'name': name,
        'bn_name': bnName,
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
