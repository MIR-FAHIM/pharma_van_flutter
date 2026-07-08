// lib/app/modules/category/controller/category_controller.dart

import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';

import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final isLoading = false.obs;
  final categories = <CategoryItem>[].obs;
  final categoryChilds = <DatumCatChild>[].obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();

  }

  Future<void> getCategories() async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = '';

    try {
      final res = await ProductRepository().getCategory();
      // Debug
      // print('Category API res = $res');

      if (res is Map && res['status'] == 'success') {
        final model = CategoryResModel.fromJson(res as Map<String, dynamic>);
        categories.assignAll(model.data?.data ?? <CategoryItem>[]);
      } else {
        categories.clear();
        error.value = (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      categories.clear();
      error.value = e.toString();
    } finally {
      isLoading.value = false;
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
        error.value = (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      categoryChilds.clear();
      error.value = e.toString();
    } finally {
      //isLoading.value = false;
    }
  }
}
