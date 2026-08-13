import 'package:ecom_user_flutter/app/models/ecom/product/brand_model.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/shop/controller/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';

class BrandListView extends GetView<ShopController> {
  const BrandListView({super.key});

  static const Color _navy = Color(0xFF1F214C);
  static const Color _green = Color(0xFF16A34A);
  static const Color _bg = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        foregroundColor: _navy,
        title: Text(
          "Manufacturer",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: _navy,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: controller.getBrands,
        //     icon: const Icon(Icons.refresh_rounded),
        //   ),
        //   const SizedBox(width: 6),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoadingBrands.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (controller.error.value.isNotEmpty) {
        //   return _ErrorState(
        //     message: controller.error.value,
        //     onRetry: controller.getBrands,
        //   );
        // }

        final brands = controller.brandList.value;

        if (brands.isEmpty) {
          return const _EmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getBrands(false);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: _HeaderCard(
                    total: brands.length,
                    active: brands.where((e) => e.isActive).length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _BrandCard(item: brands[index]);
                    },
                    childCount: brands.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.total,
    required this.active,
  });

  final int total;
  final int active;

  static const Color _navy = Color(0xFF1F214C);
  static const Color _green = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final inactive = total - active;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1F214C),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.branding_watermark_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Brand Directory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$total brands available',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SmallStatusPill(
                text: '$active Active',
                color: _green,
              ),
              const SizedBox(height: 6),
              _SmallStatusPill(
                text: '$inactive Inactive',
                color: Colors.white,
                darkText: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStatusPill extends StatelessWidget {
  const _SmallStatusPill({
    required this.text,
    required this.color,
    this.darkText = false,
  });

  final String text;
  final Color color;
  final bool darkText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
            darkText ? Colors.white.withOpacity(0.14) : color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: darkText ? Colors.white : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({
    required this.item,
  });

  final BrandItem item;

  static const Color _navy = Color(0xFF1F214C);
  static const Color _green = Color(0xFF16A34A);
  static const Color _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = (item.name ?? "-").trim();
    final logoUrl = _asImageUrl(item.logo!.fileName);
    final isActive = item.isActive;
    final statusColor = isActive ? _green : _red;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.find<ProductController>().openBrandProducts(item.id);

          // Example:
          // Get.toNamed(Routes.BRAND_PRODUCTS, arguments: {"brand_id": item.id});
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 7),
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 76,
                height: 76,
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
              const SizedBox(height: 6),
              Text(
                title.isEmpty ? "-" : title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: _navy.withOpacity(0.65),
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'View products',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _navy.withOpacity(0.75),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const Color _navy = Color(0xFF1F214C);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: _navy.withOpacity(0.08),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.branding_watermark_outlined,
                size: 42,
                color: _navy.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "No brands found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Brands will appear here when they are available.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  static const Color _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: _red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: _red.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Something went wrong",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                "Retry",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
