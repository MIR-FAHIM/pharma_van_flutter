class BrandResModel {
  final String? status;
  final String? message;
  final BrandPageData? data;

  BrandResModel({
    this.status,
    this.message,
    this.data,
  });

  factory BrandResModel.fromJson(Map<String, dynamic> json) {
    return BrandResModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? BrandPageData.fromJson(
        Map<String, dynamic>.from(json['data']),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  bool get isSuccess => status?.toLowerCase() == 'success';
}

class BrandPageData {
  final int? currentPage;
  final List<BrandItem> items;

  final int? from;
  final int? lastPage;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  final List<BrandPageLink> links;

  BrandPageData({
    this.currentPage,
    this.items = const [],
    this.from,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.perPage,
    this.to,
    this.total,
    this.links = const [],
  });

  factory BrandPageData.fromJson(Map<String, dynamic> json) {
    return BrandPageData(
      currentPage: _toInt(json['current_page']),
      items: json['data'] is List
          ? (json['data'] as List)
          .whereType<Map>()
          .map(
            (item) => BrandItem.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
      from: _toInt(json['from']),
      lastPage: _toInt(json['last_page']),
      firstPageUrl: json['first_page_url']?.toString(),
      lastPageUrl: json['last_page_url']?.toString(),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
      path: json['path']?.toString(),
      perPage: _toInt(json['per_page']),
      to: _toInt(json['to']),
      total: _toInt(json['total']),
      links: json['links'] is List
          ? (json['links'] as List)
          .whereType<Map>()
          .map(
            (item) => BrandPageLink.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': items.map((item) => item.toJson()).toList(),
      'from': from,
      'last_page': lastPage,
      'first_page_url': firstPageUrl,
      'last_page_url': lastPageUrl,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
      'links': links.map((item) => item.toJson()).toList(),
    };
  }
}

class BrandItem {
  final int? id;
  final String? name;
  final String? slug;
  final BrandLogo? logo;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandItem({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandItem.fromJson(Map<String, dynamic> json) {
    return BrandItem(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      logo: json['logo'] is Map<String, dynamic>
          ? BrandLogo.fromJson(
        Map<String, dynamic>.from(json['logo']),
      )
          : null,
      status: json['status']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo?.toJson(),
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isActive {
    final value = status?.toLowerCase().trim();

    return value == '1' || value == 'active' || value == 'true';
  }

  String get logoUrl {
    return logo?.fullUrl ?? '';
  }
}

class BrandLogo {
  final int? id;
  final String? fileOriginalName;
  final String? fileName;
  final int? userId;
  final int? fileSize;
  final String? extension;
  final String? type;
  final String? externalLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? url;

  BrandLogo({
    this.id,
    this.fileOriginalName,
    this.fileName,
    this.userId,
    this.fileSize,
    this.extension,
    this.type,
    this.externalLink,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.url,
  });

  factory BrandLogo.fromJson(Map<String, dynamic> json) {
    return BrandLogo(
      id: _toInt(json['id']),
      fileOriginalName: json['file_original_name']?.toString(),
      fileName: json['file_name']?.toString(),
      userId: _toInt(json['user_id']),
      fileSize: _toInt(json['file_size']),
      extension: json['extension']?.toString(),
      type: json['type']?.toString(),
      externalLink: json['external_link']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      deletedAt: _toDateTime(json['deleted_at']),
      url: json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_original_name': fileOriginalName,
      'file_name': fileName,
      'user_id': userId,
      'file_size': fileSize,
      'extension': extension,
      'type': type,
      'external_link': externalLink,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'url': url,
    };
  }

  String get fullUrl {
    final directUrl = url?.trim();

    if (directUrl != null && directUrl.isNotEmpty) {
      return directUrl;
    }

    final file = fileName?.trim();

    if (file == null || file.isEmpty) {
      return '';
    }

    if (file.startsWith('http')) {
      return file;
    }

    return 'https://myzooapi.myzoo.asia/public/$file';
  }
}

class BrandPageLink {
  final String? url;
  final String? label;
  final bool? active;

  BrandPageLink({
    this.url,
    this.label,
    this.active,
  });

  factory BrandPageLink.fromJson(Map<String, dynamic> json) {
    return BrandPageLink(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: _toBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();

  return int.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value == 1;

  final text = value.toString().toLowerCase().trim();

  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;

  return null;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty) return null;

  return DateTime.tryParse(text);
}