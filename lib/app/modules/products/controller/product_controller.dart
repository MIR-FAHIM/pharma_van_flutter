import 'dart:async';

import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/product_detail.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/product_model.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFilterOption {
  final String key;
  final String label;
  final int? isActive;
  final bool? featured;

  const ProductFilterOption({
    required this.key,
    required this.label,
    this.isActive,
    this.featured,
  });
}

class _ProductPageResult {
  final List<ProductModel> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const _ProductPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

class ProductController extends GetxController {
  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------

  final ProductRepository _repo = ProductRepository();

  // ---------------------------------------------------------------------------
  // Common State
  // ---------------------------------------------------------------------------

  final error = ''.obs;
  final quantity = 1.obs;

  final searchCtrl = TextEditingController().obs;
  final search = ''.obs;

  Timer? _debounce;

  // ---------------------------------------------------------------------------
  // Dropdown Data and Selected Filters
  // ---------------------------------------------------------------------------

  final categories = <CategoryItem>[].obs;
  final shops = <dynamic>[].obs;
  final selectedCategory = RxnInt();
  final selectedSubCategory = RxnInt();

  final categoryChilds = <DatumCatChild>[].obs;
  final isCategoryChildLoading = false.obs;

  final selectedShop = RxnInt();
  final selectedFilter = Rx<ProductFilterOption?>(null);

  final onlyFeatured = true.obs;
  final categoryId = RxnInt();

  final filterOptions = const <ProductFilterOption>[
    ProductFilterOption(
      key: 'all',
      label: 'All',
    ),
    ProductFilterOption(
      key: 'active',
      label: 'Active',
      isActive: 1,
    ),
    ProductFilterOption(
      key: 'inactive',
      label: 'Inactive',
      isActive: 0,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Product Detail
  // ---------------------------------------------------------------------------

  final productDetailLoading = false.obs;
  final productDetailError = ''.obs;
  final productDetail = Rxn<ProductDetail>();

  // ---------------------------------------------------------------------------
  // ProductFilterPage State
  // Uses filterProducts
  // ---------------------------------------------------------------------------

  final filterProducts = <ProductModel>[].obs;

  final filterCurrentPage = 1.obs;
  final filterLastPage = 1.obs;
  final filterTotal = 0.obs;

  final isFilterLoading = false.obs;
  final isFilterMoreLoading = false.obs;
  final hasMoreFilterProducts = true.obs;
  final isFilterPageLoaded = false.obs;

  // ---------------------------------------------------------------------------
  // CategoryWisedProducts State
  // Uses categoryWisedProducts
  // ---------------------------------------------------------------------------

  final categoryWisedProducts = <ProductModel>[].obs;



  final categoryCurrentPage = 1.obs;
  final categoryLastPage = 1.obs;
  final categoryTotal = 0.obs;

  final isCategoryLoading = false.obs;
  final isCategoryMoreLoading = false.obs;
  final hasMoreCategoryProducts = true.obs;
  final isCategoryPageLoaded = false.obs;

  // ---------------------------------------------------------------------------
  // ShopProducts State
  // Uses shopProducts
  // ---------------------------------------------------------------------------

  final shopProducts = <ProductModel>[].obs;

  final shopCurrentPage = 1.obs;
  final shopLastPage = 1.obs;
  final shopTotal = 0.obs;

  final isShopLoading = false.obs;
  final isShopMoreLoading = false.obs;
  final hasMoreShopProducts = true.obs;
  final isShopPageLoaded = false.obs;

  // ---------------------------------------------------------------------------
  // Featured Products State
  // Uses products
  // ---------------------------------------------------------------------------

  final products = <ProductModel>[].obs;

  final featuredCurrentPage = 1.obs;
  final featuredLastPage = 1.obs;
  final featuredTotal = 0.obs;

  final isFeaturedLoading = false.obs;
  final isFeaturedMoreLoading = false.obs;
  final hasMoreFeaturedProducts = true.obs;

// ---------------------------------------------------------------------------
  // Today Deal Products State
  // Uses products
  // ---------------------------------------------------------------------------

  final todayDealProducts = <ProductModel>[].obs;
  final isTodayDealPageLoaded = false.obs;
  final todayDealCurrentPage = 1.obs;
  final todayDealLastPage = 1.obs;
  final todayDealTotal = 0.obs;

  final isTodayDealLoading = false.obs;
  final isTodayDealMoreLoading = false.obs;
  final hasMoreTodayDealProducts = true.obs;

  // ---------------------------------------------------------------------------
  // Home Category Sections
  // These are mainly first-page category lists for home screen
  // ---------------------------------------------------------------------------

  final babyCareProducts = <ProductModel>[].obs;

  final groceryProducts = <ProductModel>[].obs;
  final medicineProducts = <ProductModel>[].obs;
  final healthBeautyProducts = <ProductModel>[].obs;
  final fashionProducts = <ProductModel>[].obs;
  final restaurantProducts = <ProductModel>[].obs;

  final isHomeSectionLoading = false.obs;

  // ---------------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------------

  final isCartLoading = false.obs;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    getCategories();

    getFeaturedProducts(reset: true);
    getTodayDealProducts(reset: true);

    babyCareProductsController(reset: true);
    groceryProductsController(reset: true);
    healthBeautyCareProductsController(reset: true);
    fashionProductsController(reset: true);
    medicineProductsController(reset: true);
    restaurantProductsController(reset: true);
  }

  @override
  void onClose() {
    _debounce?.cancel();
   // searchCtrl.value.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Shared Helpers
  // ---------------------------------------------------------------------------

  String? get _searchParam {
    final value = search.value.trim();
    return value.isEmpty ? null : value;
  }

  void _debounceAction(VoidCallback action) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 450),
      action,
    );
  }

  void _clearError() {
    error.value = '';
  }

  void clearSearch() {
    search.value = '';
    searchCtrl.value.clear();
  }

  _ProductPageResult _parseProductPageResponse(dynamic res) {
    if (res is Map && res['status'] == 'success') {
      final model = ProductsResponse.fromJson(
        Map<String, dynamic>.from(res),
      );

      final pageData = model.data;
      final current = pageData.currentPage;
      final last = pageData.lastPage ?? current;

      return _ProductPageResult(
        items: pageData.items,
        currentPage: current,
        lastPage: last,
        total: pageData.total ?? pageData.items.length,
      );
    }

    final message =
        res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed';

    throw Exception(message);
  }

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  Future<void> getCategories() async {
    _clearError();

    try {
      final res = await _repo.getCategory();

      if (res is Map && res['status'] == 'success') {
        final model = CategoryResModel.fromJson(
          Map<String, dynamic>.from(res),
        );

        categories.assignAll(model.data?.data ?? <CategoryItem>[]);
      } else {
        categories.clear();
        error.value =
            res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed';
      }
    } catch (e) {
      categories.clear();
      error.value = e.toString();
    }
  }

  Future<void> getCategoryChildController(id) async {
    print("i am called 568");

    error.value = '';

    try {
      final res = await ProductRepository().getCategoryChild(id);
      // Debug
      print('Category API res 56866= $res');

      if (res is Map && res['status'] == 'success') {
        final model = CategoryChildModel.fromJson(res as Map<String, dynamic>);
        categoryChilds.assignAll(model.data ?? <DatumCatChild>[]);
        print('Category API res 5566= ${categoryChilds.length}');
      } else {
        categoryChilds.clear();
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      categoryChilds.clear();
      error.value = e.toString();
    } finally {
      //isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // ProductFilterPage Methods
  // ---------------------------------------------------------------------------

  void initProductFilterPage({bool forceRefresh = false}) {
    if (isFilterPageLoaded.value && !forceRefresh) return;

    isFilterPageLoaded.value = true;
    getFilterProducts(reset: true);
  }

  void onSearchChanged(String value) {
    search.value = value.trim();

    _debounceAction(() {
      getFilterProducts(reset: true);
    });
  }

  Future<void> setFilterCategory(int? id) async {
    selectedCategory.value = id;
    selectedSubCategory.value = null;
    categoryChilds.clear();

    if (id != null) {
      await getCategoryChilds(id);
    }

    getFilterProducts(reset: true);
  }

  void setFilterSubCategory(int? id) {
    selectedSubCategory.value = id;
    getFilterProducts(reset: true);
  }

  void clearFilterCategory() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    categoryChilds.clear();

    getFilterProducts(reset: true);
  }

  void clearFilterSubCategory() {
    selectedSubCategory.value = null;
    getFilterProducts(reset: true);
  }

  void setShop(int? id) {
    selectedShop.value = id;
    getFilterProducts(reset: true);
  }

  void setFilter(ProductFilterOption? filter) {
    selectedFilter.value = filter;
    getFilterProducts(reset: true);
  }

  Future<void> getCategoryChilds(int parentCategoryId) async {
    if (isCategoryChildLoading.value) return;

    isCategoryChildLoading.value = true;
    categoryChilds.clear();

    try {
      final res = await _repo.getCategoryChild(parentCategoryId);

      if (res is Map && res['status'] == 'success') {
        final model = CategoryChildModel.fromJson(
          Map<String, dynamic>.from(res),
        );

        categoryChilds.assignAll(model.data ?? <DatumCatChild>[]);
      } else {
        categoryChilds.clear();
      }
    } catch (e) {
      categoryChilds.clear();
    } finally {
      isCategoryChildLoading.value = false;
    }
  }

  Future<void> getFilterProducts({bool reset = false}) async {
    if (reset) {
      filterCurrentPage.value = 1;
      filterLastPage.value = 1;
      filterTotal.value = 0;
      hasMoreFilterProducts.value = true;
      filterProducts.clear();
      _clearError();
    }

    if (!hasMoreFilterProducts.value && !reset) return;
    if (isFilterLoading.value || isFilterMoreLoading.value) return;

    if (reset) {
      isFilterLoading.value = true;
    } else {
      isFilterMoreLoading.value = true;
    }

    _clearError();

    try {
      final pageToLoad = reset ? 1 : filterCurrentPage.value;

      final effectiveCategoryId =
          selectedSubCategory.value ?? selectedCategory.value;

      final res = await _repo.getFilterProducts(
        page: pageToLoad,
        perPage: 20,
        shopId: selectedShop.value,
        categoryId: effectiveCategoryId,
        isActive: selectedFilter.value?.isActive,
        search: _searchParam,
      );

      final page = _parseProductPageResponse(res);

      filterLastPage.value = page.lastPage;
      filterTotal.value = page.total;

      if (reset) {
        filterProducts.assignAll(page.items);
      } else {
        filterProducts.addAll(page.items);
      }

      if (page.currentPage < page.lastPage) {
        filterCurrentPage.value = page.currentPage + 1;
        hasMoreFilterProducts.value = true;
      } else {
        filterCurrentPage.value = page.currentPage;
        hasMoreFilterProducts.value = false;
      }
    } catch (e) {
      if (reset) filterProducts.clear();
      error.value = e.toString();
    } finally {
      isFilterLoading.value = false;
      isFilterMoreLoading.value = false;
    }
  }

  Future<void> loadMoreFilterProducts() async {
    if (isFilterLoading.value || isFilterMoreLoading.value) return;
    if (!hasMoreFilterProducts.value) return;

    await getFilterProducts(reset: false);
  }

  // ---------------------------------------------------------------------------
  // CategoryWisedProducts Methods
  // ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// CategoryWisedProducts Methods
// ---------------------------------------------------------------------------

  void initCategoryWiseProductsPage({bool forceRefresh = false}) {
    if (isCategoryPageLoaded.value && !forceRefresh) return;

    isCategoryPageLoaded.value = true;

    if (selectedCategory.value != null && categoryChilds.isEmpty) {
      getCategoryChilds(selectedCategory.value!);
    }

    getCategoryWiseProduct(reset: true);
  }

  void openCategoryWiseProducts(int? id) {
    selectedCategory.value = id;
    selectedSubCategory.value = null;
    categoryId.value = id;
    categoryChilds.clear();

    clearSearch();

    if (id != null) {
      getCategoryChilds(id);
    }

    isCategoryPageLoaded.value = true;
    getCategoryWiseProduct(reset: true);

    Get.toNamed(Routes.CATEGORY_WISE_PRODUCT);
  }

  Future<void> setCategoryWiseCategory(int? id) async {
    selectedCategory.value = id;
    selectedSubCategory.value = null;
    categoryId.value = id;
    categoryChilds.clear();

    if (id != null) {
      await getCategoryChilds(id);
    }

    getCategoryWiseProduct(reset: true);
  }

  void setCategoryWiseSubCategory(int? id) {
    selectedSubCategory.value = id;
    getCategoryWiseProduct(reset: true);
  }

  void clearCategoryWiseCategory() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    categoryId.value = null;
    categoryChilds.clear();

    getCategoryWiseProduct(reset: true);
  }

  void clearCategoryWiseSubCategory() {
    selectedSubCategory.value = null;
    getCategoryWiseProduct(reset: true);
  }

  void setCategoryWiseShop(int? id) {
    selectedShop.value = id;
    getCategoryWiseProduct(reset: true);
  }

  void onSearchChangedCategoryWise(String value) {
    search.value = value.trim();

    _debounceAction(() {
      getCategoryWiseProduct(reset: true);
    });
  }

  Future<void> getCategoryWiseProduct({bool reset = false}) async {
    if (reset) {
      categoryCurrentPage.value = 1;
      categoryLastPage.value = 1;
      categoryTotal.value = 0;
      hasMoreCategoryProducts.value = true;
      categoryWisedProducts.clear();
      _clearError();
    }

    if (!hasMoreCategoryProducts.value && !reset) return;
    if (isCategoryLoading.value || isCategoryMoreLoading.value) return;

    if (reset) {
      isCategoryLoading.value = true;
    } else {
      isCategoryMoreLoading.value = true;
    }

    _clearError();

    try {
      final pageToLoad = reset ? 1 : categoryCurrentPage.value;

      final effectiveCategoryId =
          selectedSubCategory.value ?? selectedCategory.value;

      final res = await _repo.getFilterProducts(
        page: pageToLoad,
        perPage: 20,
        shopId: selectedShop.value,
        categoryId: effectiveCategoryId,
        isActive: selectedFilter.value?.isActive,
        search: _searchParam,
      );

      final page = _parseProductPageResponse(res);

      categoryLastPage.value = page.lastPage;
      categoryTotal.value = page.total;

      if (reset) {
        categoryWisedProducts.assignAll(page.items);
      } else {
        categoryWisedProducts.addAll(page.items);
      }

      if (page.currentPage < page.lastPage) {
        categoryCurrentPage.value = page.currentPage + 1;
        hasMoreCategoryProducts.value = true;
      } else {
        categoryCurrentPage.value = page.currentPage;
        hasMoreCategoryProducts.value = false;
      }
    } catch (e) {
      if (reset) categoryWisedProducts.clear();
      error.value = e.toString();
    } finally {
      isCategoryLoading.value = false;
      isCategoryMoreLoading.value = false;
    }
  }

  Future<void> loadMoreCategoryWiseProducts() async {
    if (isCategoryLoading.value || isCategoryMoreLoading.value) return;
    if (!hasMoreCategoryProducts.value) return;

    await getCategoryWiseProduct(reset: false);
  }

  // ---------------------------------------------------------------------------
  // ShopProducts Methods
  // ---------------------------------------------------------------------------

  void initShopProductsPage({bool forceRefresh = false}) {
    if (isShopPageLoaded.value && !forceRefresh) return;

    isShopPageLoaded.value = true;
    getShopProducts(reset: true);
  }

  void openShopProducts(int? shopId) {
    selectedShop.value = shopId;

    clearSearch();

    isShopPageLoaded.value = true;
    getShopProducts(reset: true);

    Get.toNamed(Routes.SHOP_PRODUCT);
  }

  void setShopProductCategory(int? id) {
    selectedCategory.value = id;
    getShopProducts(reset: true);
  }

  void setShopProductShop(int? id) {
    selectedShop.value = id;
    getShopProducts(reset: true);
  }

  void onSearchChangedShopProducts(String value) {
    search.value = value.trim();

    _debounceAction(() {
      getShopProducts(reset: true);
    });
  }

  Future<void> getShopProducts({bool reset = false}) async {
    if (reset) {
      shopCurrentPage.value = 1;
      shopLastPage.value = 1;
      shopTotal.value = 0;
      hasMoreShopProducts.value = true;
      shopProducts.clear();
      _clearError();
    }

    if (!hasMoreShopProducts.value && !reset) return;
    if (isShopLoading.value || isShopMoreLoading.value) return;

    if (reset) {
      isShopLoading.value = true;
    } else {
      isShopMoreLoading.value = true;
    }

    _clearError();

    try {
      final pageToLoad = reset ? 1 : shopCurrentPage.value;

      final res = await _repo.getFilterProducts(
        page: pageToLoad,
        perPage: 20,
        shopId: selectedShop.value,
        categoryId: selectedCategory.value,
        isActive: selectedFilter.value?.isActive,
        search: _searchParam,
      );

      final page = _parseProductPageResponse(res);

      shopLastPage.value = page.lastPage;
      shopTotal.value = page.total;

      if (reset) {
        shopProducts.assignAll(page.items);
      } else {
        shopProducts.addAll(page.items);
      }

      if (page.currentPage < page.lastPage) {
        shopCurrentPage.value = page.currentPage + 1;
        hasMoreShopProducts.value = true;
      } else {
        shopCurrentPage.value = page.currentPage;
        hasMoreShopProducts.value = false;
      }
    } catch (e) {
      if (reset) shopProducts.clear();
      error.value = e.toString();
    } finally {
      isShopLoading.value = false;
      isShopMoreLoading.value = false;
    }
  }

  Future<void> loadMoreShopProducts() async {
    if (isShopLoading.value || isShopMoreLoading.value) return;
    if (!hasMoreShopProducts.value) return;

    await getShopProducts(reset: false);
  }

  // ---------------------------------------------------------------------------
  // Featured Products Methods
  // ---------------------------------------------------------------------------

  Future<void> getFeaturedProducts({bool reset = false}) async {
    if (reset) {
      featuredCurrentPage.value = 1;
      featuredLastPage.value = 1;
      featuredTotal.value = 0;
      hasMoreFeaturedProducts.value = true;
      products.clear();
      _clearError();
    }

    if (!hasMoreFeaturedProducts.value && !reset) return;
    if (isFeaturedLoading.value || isFeaturedMoreLoading.value) return;

    if (reset) {
      isFeaturedLoading.value = true;
    } else {
      isFeaturedMoreLoading.value = true;
    }

    _clearError();

    try {
      final pageToLoad = reset ? 1 : featuredCurrentPage.value;

      final res = await _repo.getFeaturedProducts(
        page: pageToLoad,
        perPage: 20,
        shopId: selectedShop.value,
        categoryId: selectedCategory.value,
        isActive: selectedFilter.value?.isActive,
        search: _searchParam,
      );

      final page = _parseProductPageResponse(res);

      featuredLastPage.value = page.lastPage;
      featuredTotal.value = page.total;

      if (reset) {
        products.assignAll(page.items);
      } else {
        products.addAll(page.items);
      }

      if (page.currentPage < page.lastPage) {
        featuredCurrentPage.value = page.currentPage + 1;
        hasMoreFeaturedProducts.value = true;
      } else {
        featuredCurrentPage.value = page.currentPage;
        hasMoreFeaturedProducts.value = false;
      }
    } catch (e) {
      if (reset) products.clear();
      error.value = e.toString();
    } finally {
      isFeaturedLoading.value = false;
      isFeaturedMoreLoading.value = false;
    }
  }

  Future<void> loadMoreFeatured() async {
    if (isFeaturedLoading.value || isFeaturedMoreLoading.value) return;
    if (!hasMoreFeaturedProducts.value) return;

    await getFeaturedProducts(reset: false);
  }

  Future<void> refreshFeatured() async {
    await getFeaturedProducts(reset: true);
  }

  void setOnlyFeatured(bool value) {
    onlyFeatured.value = value;
    getFeaturedProducts(reset: true);
  }

  // ---------------------------------------------------------------------------
  // Home Category Section Methods
  // These do not use shared pagination. They just load first page for home UI.
  // ---------------------------------------------------------------------------

  Future<void> _loadHomeCategorySection({
    required RxList<ProductModel> targetList,
    required int categoryId,
    bool reset = false,
  }) async {
    if (reset) {
      targetList.clear();
    }

    isHomeSectionLoading.value = true;

    try {
      final res = await _repo.getFilterProducts(
        page: 1,
        perPage: 20,
        categoryId: categoryId,
        shopId: null,
        isActive: selectedFilter.value?.isActive,
        search: null,
      );

      final page = _parseProductPageResponse(res);
      targetList.assignAll(page.items);
    } catch (e) {
      if (reset) targetList.clear();
      error.value = e.toString();
    } finally {
      isHomeSectionLoading.value = false;
    }
  }

  Future<void> babyCareProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: babyCareProducts,
      categoryId: 11,
      reset: reset,
    );
  }

  Future<void> groceryProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: groceryProducts,
      categoryId: 4,
      reset: reset,
    );
  }

  Future<void> medicineProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: medicineProducts,
      categoryId: 348,
      reset: reset,
    );
  }

  Future<void> healthBeautyCareProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: healthBeautyProducts,
      categoryId: 11,
      reset: reset,
    );
  }

  Future<void> fashionProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: fashionProducts,
      categoryId: 5,
      reset: reset,
    );
  }

  Future<void> restaurantProductsController({bool reset = false}) async {
    await _loadHomeCategorySection(
      targetList: restaurantProducts,
      categoryId: 6,
      reset: reset,
    );
  }

// ---------------------------------------------------------------------------
// Today Deal Products Methods
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Today Deal Products Methods
// ---------------------------------------------------------------------------

  void initTodayDealProductsPage({bool forceRefresh = false}) {
    if (isTodayDealPageLoaded.value && !forceRefresh) return;

    isTodayDealPageLoaded.value = true;

    if (selectedCategory.value != null && categoryChilds.isEmpty) {
      getCategoryChilds(selectedCategory.value!);
    }

    getTodayDealProducts(reset: true);
  }

  void openTodayDealProducts() {
    clearSearch();

    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedShop.value = null;
    selectedFilter.value = null;
    categoryChilds.clear();

    isTodayDealPageLoaded.value = true;
    getTodayDealProducts(reset: true);

    Get.toNamed(Routes.TODAY_DEAL_PRODUCT);
  }

  Future<void> setTodayDealCategory(int? id) async {
    selectedCategory.value = id;
    selectedSubCategory.value = null;
    categoryChilds.clear();

    if (id != null) {
      await getCategoryChilds(id);
    }

    getTodayDealProducts(reset: true);
  }

  void setTodayDealSubCategory(int? id) {
    selectedSubCategory.value = id;
    getTodayDealProducts(reset: true);
  }

  void clearTodayDealCategory() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    categoryChilds.clear();

    getTodayDealProducts(reset: true);
  }

  void clearTodayDealSubCategory() {
    selectedSubCategory.value = null;
    getTodayDealProducts(reset: true);
  }

  void setTodayDealShop(int? id) {
    selectedShop.value = id;
    getTodayDealProducts(reset: true);
  }

  void onSearchChangedTodayDealProducts(String value) {
    search.value = value.trim();

    _debounceAction(() {
      getTodayDealProducts(reset: true);
    });
  }

  Future<void> getTodayDealProducts({bool reset = false}) async {
    if (reset) {
      todayDealCurrentPage.value = 1;
      todayDealLastPage.value = 1;
      todayDealTotal.value = 0;
      hasMoreTodayDealProducts.value = true;
      todayDealProducts.clear();
      _clearError();
    }

    if (!hasMoreTodayDealProducts.value && !reset) return;
    if (isTodayDealLoading.value || isTodayDealMoreLoading.value) return;

    if (reset) {
      isTodayDealLoading.value = true;
    } else {
      isTodayDealMoreLoading.value = true;
    }

    _clearError();

    try {
      final pageToLoad = reset ? 1 : todayDealCurrentPage.value;

      final effectiveCategoryId =
          selectedSubCategory.value ?? selectedCategory.value;

      final res = await _repo.getTodayDealProducts(
        page: pageToLoad,
        perPage: 20,
        shopId: selectedShop.value,
        categoryId: effectiveCategoryId,
        isActive: null,
        search: _searchParam,
      );

      final page = _parseProductPageResponse(res);

      todayDealLastPage.value = page.lastPage;
      todayDealTotal.value = page.total;

      if (reset) {
        todayDealProducts.assignAll(page.items);
      } else {
        todayDealProducts.addAll(page.items);
      }

      if (page.currentPage < page.lastPage) {
        todayDealCurrentPage.value = page.currentPage + 1;
        hasMoreTodayDealProducts.value = true;
      } else {
        todayDealCurrentPage.value = page.currentPage;
        hasMoreTodayDealProducts.value = false;
      }
    } catch (e) {
      if (reset) todayDealProducts.clear();
      error.value = e.toString();
    } finally {
      isTodayDealLoading.value = false;
      isTodayDealMoreLoading.value = false;
    }
  }

  Future<void> loadMoreTodayDealProducts() async {
    if (isTodayDealLoading.value || isTodayDealMoreLoading.value) return;
    if (!hasMoreTodayDealProducts.value) return;

    await getTodayDealProducts(reset: false);
  }
  // ---------------------------------------------------------------------------
  // Product Detail
  // ---------------------------------------------------------------------------

  Future<void> getProductDetail(int productId) async {
    if (productDetailLoading.value) return;

    productDetailLoading.value = true;
    productDetailError.value = '';
    productDetail.value = null;

    try {
      final res = await _repo.getProductDetail(productId);

      if (res is Map && res['status'] == 'success') {
        final model = ProductDetailResModel.fromJson(
          Map<String, dynamic>.from(res),
        );

        productDetail.value = model.data;

        Get.toNamed(Routes.PRODUCT_DETAIL);
      } else {
        productDetailError.value =
            res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed';
      }
    } catch (e) {
      productDetailError.value = e.toString();
    } finally {
      productDetailLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------------

  Future<void> addToCart({
    required dynamic productId,
    required dynamic qty,
  }) async {
    if (isCartLoading.value) return;

    isCartLoading.value = true;
   if(Get.find<AuthService>().currentUser.value.data == null){
     Get.toNamed(Routes.LOGIN);
   }
    final userId =
        Get.find<AuthService>().currentUser.value.data?.user?.id.toString();

    if (userId == null) {
      isCartLoading.value = false;

      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'User not found',
          title: 'Error'.tr,
        ),
      );
      return;
    }

    final data = {
      'user_id': userId,
      'product_id': productId.toString(),
      'qty': qty.toString(),
    };

    try {
      final res = await _repo.addToCart(data);

      if (res is Map && res['status'] == 'success') {
        Get.find<CartController>().getActiveCart();

        Get.showSnackbar(
          Ui.SuccessSnackBar(
            message: res['message']?.toString() ?? 'Added to cart',
            title: 'Success'.tr,
          ),
        );
      } else {
        Get.showSnackbar(
          Ui.ErrorSnackBar(
            message: res is Map
                ? (res['message']?.toString() ?? 'Failed')
                : 'Failed',
            title: 'Error'.tr,
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: e.toString(),
          title: 'Error'.tr,
        ),
      );
    } finally {
      isCartLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Quantity Helpers
  // ---------------------------------------------------------------------------

  void resetQty() {
    quantity.value = 1;
  }

  void increaseQty({required int maxStock}) {
    if (maxStock <= 0) return;

    if (quantity.value < maxStock) {
      quantity.value++;
    }
  }

  void decreaseQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
