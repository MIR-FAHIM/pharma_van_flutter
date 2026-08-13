import 'package:ecom_user_flutter/app/models/ecom/product/brand_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final shopList = <DatumShop>[].obs;
  final brandList = <BrandItem>[].obs;

  final isLoadingShops = false.obs;
  final isLoadingBrands = false.obs;

  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    getShops(true);
    getBrands(true);
  }

  Future<void> getShops(isHome) async {
    try {
      isLoadingShops.value = true;
      error.value = '';
      Map<String, dynamic> param = {'status': 'active'};
      final response = await ProductRepository().getShop(params: param);

      if (response is Map<String, dynamic>) {
        final model = ShopListResModel.fromJson(response);

        if (model.status == "success") {
          shopList.assignAll(model.data?.data ?? []);

          if(isHome == false){
            Get.toNamed(Routes.SHOP_LIST);
          }


        } else {
          error.value = model.message ?? 'Failed to load shops';
          shopList.clear();
        }
      } else {
        error.value = 'Invalid response';
        shopList.clear();
      }
    } catch (e) {
      error.value = e.toString();
      shopList.clear();
    } finally {
      isLoadingShops.value = false;
    }
  }

  Future<void> getBrands(isHome) async {
    try {
      isLoadingBrands.value = true;

      final response = await ProductRepository().getBrands();

      print("get brand list 62435 $response");

      if (response is Map<String, dynamic>) {
        final model = BrandResModel.fromJson(response);

        if (model.status == "success") {
          brandList.assignAll(model.data?.items ?? []);

          if(isHome == false){
            Get.toNamed(Routes.BRAND_LIST);
          }

        } else {
          brandList.clear();
        }
      } else {
        brandList.clear();
      }
    } catch (e) {
      brandList.clear();
    } finally {
      isLoadingBrands.value = false;
    }
  }
}
