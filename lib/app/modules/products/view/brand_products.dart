// lib/app/modules/products/view/brand_products.dart

import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandProducts extends GetView<ProductController> {
  const BrandProducts({super.key});

  static const Color _primary = Color(0xFF1F214C);
  static const Color _background = Color(0xFFF6F7FB);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initBrandProductsPage();
    });

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Manufacturer Products',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: Obx(() {
                return _buildProductBody(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: _border,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSearchField(),

          const SizedBox(height: 12),

          _buildCategoryFilters(),

          const SizedBox(height: 12),

          _buildProductCount(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchCtrl.value,
      onChanged: controller.onSearchChangedBrandProducts,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search brand products...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: _primary,
        ),
        suffixIcon: Obx(() {
          if (controller.search.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return IconButton(
            onPressed: () {
              controller.clearSearch();
              controller.getBrandProducts(
                reset: true,
              );
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          );
        }),
        filled: true,
        fillColor: _background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Obx(() {
      final categoryItems = controller.categories;
      final subCategoryItems = controller.categoryChilds;
      final childCategoryItems = controller.subCategoryChilds;

      final selectedCategory = controller.selectedCategory.value == null
          ? null
          : categoryItems.firstWhereOrNull(
            (item) {
          return item.id ==
              controller.selectedCategory.value;
        },
      );

      final selectedSubCategory =
      controller.selectedSubCategory.value == null
          ? null
          : subCategoryItems.firstWhereOrNull(
            (item) {
          return item.id ==
              controller.selectedSubCategory.value;
        },
      );

      final selectedChildCategory =
      controller.selectedChildCategory.value == null
          ? null
          : childCategoryItems.firstWhereOrNull(
            (item) {
          return item.id ==
              controller.selectedChildCategory.value;
        },
      );

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterDropBox<CategoryItem>(
                  hint: 'Category',
                  value: selectedCategory,
                  items: categoryItems,
                  labelOf: (item) {
                    return (item.name ?? 'Category').trim();
                  },
                  onChanged: (item) {
                    controller.setBrandProductCategory(
                      item?.id,
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _FilterDropBox<DatumCatChild>(
                  hint: controller.isCategoryChildLoading.value
                      ? 'Loading...'
                      : 'Subcategory',
                  value: selectedSubCategory,
                  items: subCategoryItems,
                  enabled:
                  !controller.isCategoryChildLoading.value &&
                      controller.selectedCategory.value != null,
                  labelOf: (item) {
                    return (item.name ?? 'Subcategory').trim();
                  },
                  onChanged: (item) {
                    controller.setBrandProductSubCategory(
                      item?.id,
                    );
                  },
                ),
              ),
            ],
          ),

          if (controller.selectedSubCategory.value != null ||
              childCategoryItems.isNotEmpty) ...[
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _FilterDropBox<DatumCatChild>(
                    hint:
                    controller.isSubCategoryChildLoading.value
                        ? 'Loading...'
                        : 'Child Category',
                    value: selectedChildCategory,
                    items: childCategoryItems,
                    enabled:
                    !controller.isSubCategoryChildLoading.value &&
                        controller.selectedSubCategory.value !=
                            null,
                    labelOf: (item) {
                      return (item.name ?? 'Child Category')
                          .trim();
                    },
                    onChanged: (item) {
                      controller.setBrandProductChildCategory(
                        item?.id,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: controller.clearBrandProductFilters,
                    icon: const Icon(
                      Icons.restart_alt_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primary,
                      side: const BorderSide(
                        color: _border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }

  Widget _buildProductCount() {
    return Obx(() {
      return Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 19,
              color: _primary,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Products',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.brandTotal.value}',
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProductBody(BuildContext context) {
    if (controller.isBrandLoading.value &&
        controller.brandProducts.isEmpty) {
      return const _BrandLoadingState();
    }

    if (controller.error.value.isNotEmpty &&
        controller.brandProducts.isEmpty) {
      return _ErrorState(
        message: controller.error.value,
        onRetry: () {
          controller.getBrandProducts(
            reset: true,
          );
        },
      );
    }

    if (controller.brandProducts.isEmpty) {
      return _EmptyState(
        onReset: controller.clearBrandProductFilters,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 300) {
          controller.loadMoreBrandProducts();
        }

        return false;
      },
      child: RefreshIndicator(
        color: _primary,
        onRefresh: controller.refreshBrandProducts,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
            constraints.maxWidth >= 700 ? 3 : 2;

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                10,
                12,
                10,
                24,
              ),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: controller.brandProducts.length +
                  (controller.isBrandMoreLoading.value ? 1 : 0),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                if (index >=
                    controller.brandProducts.length) {
                  return const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _primary,
                      ),
                    ),
                  );
                }

                final product =
                controller.brandProducts[index];

                return ProductCard(
                  product: product,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FilterDropBox<T> extends StatelessWidget {
  const _FilterDropBox({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.enabled = true,
  });

  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) labelOf;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
      ),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.white
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          menuMaxHeight: 340,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled
                ? const Color(0xFF1F214C)
                : Colors.grey,
          ),
          hint: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: enabled
                  ? Colors.black54
                  : Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: const Text(
                'All',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ...items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  labelOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            }),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

class _BrandLoadingState extends StatelessWidget {
  const _BrandLoadingState();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        10,
        12,
        10,
        24,
      ),
      itemCount: 9,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                    const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 7),
                      Container(
                        height: 10,
                        width: 65,
                        color: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onReset,
  });

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF1F214C),
      onRefresh: () async {
        onReset();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.52,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F214C)
                            .withOpacity(0.07),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 42,
                        color: const Color(0xFF1F214C)
                            .withOpacity(0.65),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'No Brand Products Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Try changing the category or search filters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: onReset,
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                      ),
                      label: const Text(
                        'Clear Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 38,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF1F214C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}