import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/modules/category/controller/category_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeCategoryChildRow extends GetView<CategoryController> {
  const HomeCategoryChildRow({
    super.key,
    required this.title,

    required this.onSeeAllTap,
    required this.onItemTap,
    this.backgroundColor,
    this.height = 190,
  });

  final String title;

  final VoidCallback onSeeAllTap;
  final void Function(DatumCatChild item) onItemTap;
  final Color? backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {


    return Obx(

      () {

        List<DatumCatChild> items = controller.categoryChilds ;
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          color: backgroundColor ?? AppColors.primaryDarkGreen.withOpacity(0.60),
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                title: title,
                onSeeAllTap: onSeeAllTap,
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: height,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == items.length - 1 ? 0 : 14,
                      ),
                      child: _CategoryChildCard(
                        item: item,
                        onTap: () => onItemTap(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
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
                fontSize: 22,
                height: 1,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "See All",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChildCard extends StatelessWidget {
  const _CategoryChildCard({
    required this.item,
    required this.onTap,
  });

  final DatumCatChild item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = item.name.trim();
    final imageUrl = _getCategoryImageUrl(item);

    return Material(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 145,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Expanded(
                  flex: 68,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: imageUrl.isEmpty
                        ? _CategoryImagePlaceholder(
                      title: title,
                    )
                        : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _CategoryImagePlaceholder(
                          title: title,
                        );
                      },
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;

                        return Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  flex: 32,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFE9E9E9),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryImagePlaceholder extends StatelessWidget {
  const _CategoryImagePlaceholder({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.06),
      child: Center(
        child: Icon(
          Icons.category_outlined,
          color: AppColors.primaryColor.withOpacity(0.45),
          size: 34,
        ),
      ),
    );
  }
}

String _getCategoryImageUrl(DatumCatChild item) {
  final coverUrl = item.coverImage?.url?.toString();
  final coverFile = item.coverImage?.fileName;

  final bannerUrl = item.banner?.url?.toString();
  final bannerFile = item.banner?.fileName;

  final icon = item.icon;

  if (coverUrl != null && coverUrl.trim().isNotEmpty) {
    return _asImageUrl(coverUrl);
  }

  if (coverFile != null && coverFile.trim().isNotEmpty) {
    return _asImageUrl(coverFile);
  }

  if (bannerUrl != null && bannerUrl.trim().isNotEmpty) {
    return _asImageUrl(bannerUrl);
  }

  if (bannerFile != null && bannerFile.trim().isNotEmpty) {
    return _asImageUrl(bannerFile);
  }

  if (icon != null && icon.trim().isNotEmpty) {
    return _asImageUrl(icon);
  }

  return '';
}

String _asImageUrl(String fileName) {
  final value = fileName.trim();

  if (value.isEmpty) return '';
  if (value.startsWith('http')) return value;

  final base = CompanyData.image_file_url.endsWith('/')
      ? CompanyData.image_file_url.substring(
    0,
    CompanyData.image_file_url.length - 1,
  )
      : CompanyData.image_file_url;

  final file = value.startsWith('/') ? value : '/$value';

  return '$base$file';
}