// lib/app/modules/products/view/shop_products.dart

import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';

class ShopProducts extends GetView<ProductController> {
  const ShopProducts({super.key});

  static const Color _navy = Color(0xFF1F214C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initShopProductsPage();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: controller.searchCtrl.value,
                onChanged: controller.onSearchChangedShopProducts,
                decoration: InputDecoration(
                  hintText: 'Search anything...',
                  suffixIcon: const Icon(Icons.search),
                  prefixIcon: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final categories = controller.categories;

                      return _DropBox<CategoryItem>(
                        hint: "Product",
                        value: controller.selectedCategory.value == null
                            ? null
                            : categories.firstWhereOrNull(
                              (e) =>
                          e.id == controller.selectedCategory.value,
                        ),
                        items: categories,
                        labelOf: (c) => (c.name ?? "Category").trim(),
                        onChanged: (v) {
                          controller.setShopProductCategory(v?.id);
                        },
                      );
                    }),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Obx(() {
                      final shops = controller.shops;

                      return _DropBox<dynamic>(
                        hint: "Seller",
                        value: controller.selectedShop.value == null
                            ? null
                            : shops.firstWhereOrNull(
                              (e) => e.id == controller.selectedShop.value,
                        ),
                        items: shops,
                        labelOf: (s) => (s.name ?? "Seller").toString(),
                        onChanged: (v) {
                          controller.setShopProductShop(v?.id);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Products",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      "${controller.shopTotal.value}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _navy,
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                if (controller.isShopLoading.value &&
                    controller.shopProducts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value.isNotEmpty &&
                    controller.shopProducts.isEmpty) {
                  return _ErrorState(
                    message: controller.error.value,
                    onRetry: () {
                      controller.getShopProducts(reset: true);
                    },
                  );
                }

                if (controller.shopProducts.isEmpty) {
                  return const _EmptyState();
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (sn) {
                    if (sn.metrics.axis == Axis.vertical &&
                        sn.metrics.pixels >=
                            sn.metrics.maxScrollExtent - 250) {
                      controller.loadMoreShopProducts();
                    }

                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.getShopProducts(reset: true);
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: controller.shopProducts.length +
                          (controller.isShopMoreLoading.value ? 1 : 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        if (index >= controller.shopProducts.length) {
                          return const Center(
                            child: SizedBox(
                              height: 26,
                              width: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        final product = controller.shopProducts[index];

                        return ProductCard(product: product);
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropBox<T> extends StatelessWidget {
  const _DropBox({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: const Text(
                "All",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            ...items.map((e) {
              return DropdownMenuItem<T>(
                value: e,
                child: Text(
                  labelOf(e),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
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
            Icon(
              Icons.search_off,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            const Text(
              "No products found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Try changing search or filters.",
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
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
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