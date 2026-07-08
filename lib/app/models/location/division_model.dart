import 'dart:convert';

DivisionResponse divisionResponseFromJson(String str) =>
    DivisionResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String divisionResponseToJson(DivisionResponse data) =>
    json.encode(data.toJson());

class DivisionResponse {
  final String? status;
  final String? message;
  final List<DivisionModel> data;

  const DivisionResponse({
    this.status,
    this.message,
    required this.data,
  });

  factory DivisionResponse.fromJson(Map<String, dynamic> json) =>
      DivisionResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        data: json['data'] is List
            ? (json['data'] as List)
                .map((item) => DivisionModel.fromJson(
                      Map<String, dynamic>.from(item as Map),
                    ))
                .toList()
            : <DivisionModel>[],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };
}

class DivisionModel {
  final int? id;
  final String? name;
  final String? bnName;
  final String? url;

  const DivisionModel({
    this.id,
    this.name,
    this.bnName,
    this.url,
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) => DivisionModel(
        id: _asInt(json['id']),
        name: json['name']?.toString(),
        bnName: json['bn_name']?.toString(),
        url: json['url']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
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
