// lib/app/modules/products/view/widgets/baby_care_home.dart

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/app/modules/shop/controller/shop_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeShopListSection extends GetView<ShopController> {
  const HomeShopListSection({super.key});

  static const int _groceryCategoryId = 4;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoadingShops.value;
      final shops = controller.shopList.value;

      if (loading && shops.isEmpty) {
        return const _BabyCareSkeleton();
      }

      if (shops.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: "Manufacturer",
              onSeeAllTap: () {
                controller.getShops(false);
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: shops.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  if (shops[index].logo == null) {
                    return Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://placehold.co/400',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Icon(
                                  Icons.branding_watermark_outlined,
                                  color: Colors.black38,
                                  size: 34,
                                );
                              },
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;

                                return const Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Text(shops[index].name!)
                      ],
                    );
                  } else {
                    var logoUrl = _asImageUrl(shops[index].logo!.fileName);
                    return InkWell(
                      onTap: (){
                        Get.find<ProductController>().openShopProducts(shops[index].id);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: logoUrl.isEmpty
                                  ? const Icon(
                                      Icons.branding_watermark_outlined,
                                      color: Colors.black38,
                                      size: 34,
                                    )
                                  : Image.network(
                                      logoUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.branding_watermark_outlined,
                                          color: Colors.black38,
                                          size: 34,
                                        );
                                      },
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;

                                        return const Center(
                                          child: SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(shops[index].name!)
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

String _asImageUrl(String? fileName) {
  if (fileName == null || fileName.trim().isEmpty) return '';
  if (fileName.startsWith('http')) return fileName;

  final base = CompanyData.image_file_url.endsWith('/')
      ? CompanyData.image_file_url.substring(
          0,
          CompanyData.image_file_url.length - 1,
        )
      : CompanyData.image_file_url;

  final file = fileName.startsWith('/') ? fileName : '/$fileName';

  return '$base$file';
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSeeAllTap,
  });

  final String title;
  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: 1.1,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onSeeAllTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              child: Text(
                "See All",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BabyCareSkeleton extends StatelessWidget {
  const _BabyCareSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _SkeletonBox(
                  width: 110,
                  height: 20,
                  radius: 6,
                ),
                const Spacer(),
                _SkeletonBox(
                  width: 42,
                  height: 12,
                  radius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 214,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, __) {
                return const _ProductSkeletonCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSkeletonCard extends StatelessWidget {
  const _ProductSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.borderColor,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 52,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            flex: 48,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(7),
              color: const Color(0xFFF3F4F6),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 90, height: 10, radius: 5),
                  SizedBox(height: 5),
                  _SkeletonBox(width: 70, height: 9, radius: 5),
                  Spacer(),
                  _SkeletonBox(width: 55, height: 14, radius: 6),
                  SizedBox(height: 6),
                  _SkeletonBox(width: 100, height: 9, radius: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
