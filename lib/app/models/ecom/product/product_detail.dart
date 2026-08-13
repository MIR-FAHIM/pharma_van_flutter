// lib/app/models/product/product_detail_model.dart

import 'dart:convert';

ProductDetailResModel productDetailResModelFromJson(String str) =>
    ProductDetailResModel.fromJson(json.decode(str));

class ProductDetailResModel {
  final String? status;
  final String? message;
  final ProductDetail? data;

  ProductDetailResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProductDetailResModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailResModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProductDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
class ProductDetail {
  final int id;
  final String? name;
  final String? description;
  final int unitPrice;
  final String? unit;
  final int currentStock;
  final int minQty;
  final int discount;
  final String? discountType;
  final int rating;
  final bool cashOnDelivery;
  final bool featured;
  final int earnPoint;
  final int numOfSale;

  final MediaFile? primaryImage;
  final List<MediaFile> images;

  final Category? category;
  final Category? subCategory;
  final Shop? shop;
  final Brand? brand;

  ProductDetail({
    required this.id,
    this.name,
    this.description,
    required this.unitPrice,
    this.unit,
    required this.currentStock,
    required this.minQty,
    required this.discount,
    this.discountType,
    required this.rating,
    required this.cashOnDelivery,
    required this.featured,
    required this.earnPoint,
    required this.numOfSale,
    this.primaryImage,
    required this.images,
    this.category,
    this.subCategory,
    this.shop,
    this.brand,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      unitPrice: _asInt(json['unit_price']),
      unit: json['unit'],
      currentStock: _asInt(json['current_stock']),
      minQty: _asInt(json['min_qty']),
      discount: _asInt(json['discount']),
      discountType: json['discount_type'],
      rating: _asInt(json['rating']),
      cashOnDelivery: _asBool(json['cash_on_delivery']),
      featured: _asBool(json['featured']),
      earnPoint: _asInt(json['earn_point']),
      numOfSale: _asInt(json['num_of_sale']),
      primaryImage: json['primary_image'] == null
          ? null
          : MediaFile.fromJson(json['primary_image']),
      images: (json['images'] as List? ?? [])
          .map((e) => MediaFile.fromJson(e))
          .toList(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category']),
      subCategory: json['sub_category'] == null
          ? null
          : Category.fromJson(json['sub_category']),
      shop:
      json['shop'] == null ? null : Shop.fromJson(json['shop']),

      brand:
      json['brand'] == null ? null : Brand.fromJson(json['brand']),
    );
  }
}
class MediaFile {
  final int id;
  final String? fileName;
  final String? url;

  MediaFile({
    required this.id,
    this.fileName,
    this.url,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'],
      fileName: json['file_name'],
      url: json['url'],
    );
  }

  /// Use this everywhere in UI
  String? resolvedUrl({required String baseUrl}) {
    if (url != null && url!.isNotEmpty) return url;
    if (fileName != null && fileName!.isNotEmpty) {
      return '$baseUrl$fileName';
    }
    return null;
  }
}
class Category {
  final int id;
  final String? name;
  final String? slug;

  Category({
    required this.id,
    this.name,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}
class Shop {
  final int id;
  final String? name;
  final String? shopName;
  final String? phone;
  final String? avatar;

  Shop({
    required this.id,
    this.name,
    this.shopName,
    this.phone,
    this.avatar,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      shopName: json['shop_name'],
      phone: json['phone'],
      avatar: json['avatar_original'],
    );
  }
}

class Brand {
  final int id;
  final String? name;


  Brand({
    required this.id,
    this.name,

  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],

    );
  }
}
int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

bool _asBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is String) return v == '1' || v.toLowerCase() == 'true';
  return false;
}
