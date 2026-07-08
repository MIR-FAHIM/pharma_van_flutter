// lib/app/modules/category/views/all_category_view.dart

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/root/controllers/root_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';
import 'package:ecom_user_flutter/app/modules/category/controller/category_controller.dart';

class AllCategoryView extends GetView<CategoryController> {
  const AllCategoryView({super.key});

  static const Color _navy = Color(0xFF1F214C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.find<RootController>().currentIndex.value = 0,
        ),
        title: Text(
          "All Categories",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
      ),
      body: Obx(() {
        final loading = controller.isLoading.value;
        final items = controller.categories;
        final err = controller.error.value;

        if (loading && items.isEmpty) {
          return const _AllCategorySkeleton();
        }

        if (items.isEmpty) {
          if (err.isNotEmpty) {
            return _ErrorState(
              message: err,
              onRetry: controller.getCategories,
            );
          }
          return const _EmptyState();
        }

        return RefreshIndicator(
          color: _navy,
          onRefresh: () async => controller.getCategories(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: items.length,
            itemBuilder: (_, i) => _CategoryTile(item: items[i]),
          ),
        );
      }),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = (item.name ?? "").trim();
    final imageUrl = item.banner?.resolvedUrl(baseUrl: CompanyData.image_file_url);
    final bg = _colorFromId(item.id);

    return InkWell(
      onTap: () {
        // TODO: Navigate to category wise product page
         //Get.toNamed(Routes.CATEGORY_WISE_PRODUCT, arguments: {"id": item.id, "name": item.name});

        Get.find<ProductController>().setCategoryWiseCategory(item.id);
        Get.find<ProductController>().getCategoryWiseProduct(reset: true);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.04),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: bg.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: (imageUrl == null || imageUrl.trim().isEmpty)
                  ? const Icon(Icons.category_outlined, color: Colors.black87)
                  : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.category_outlined, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isEmpty ? "Category" : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap to explore products",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Icons.chevron_right, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromId(int? id) {
    const palette = [
      Color(0xFFF4D02D),
      Color(0xFFA1A39A),
      Color(0xFFD2C1B1),
      Color(0xFFB89C9A),
      Color(0xFFB7D7B0),
      Color(0xFFF6EAD3),
      Color(0xFFBFD7EA),
      Color(0xFFE7C6FF),
    ];
    final i = (id ?? 0).abs() % palette.length;
    return palette[i];
  }
}

class _AllCategorySkeleton extends StatelessWidget {
  const _AllCategorySkeleton();

  @override
  Widget build(BuildContext context) {
    Widget row() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: double.infinity, color: Colors.grey.shade200),
                const SizedBox(height: 10),
                Container(height: 12, width: 140, color: Colors.grey.shade200),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          )
        ],
      ),
    );

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: 8,
      itemBuilder: (_, __) => row(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              "No categories found",
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
