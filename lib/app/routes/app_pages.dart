
import 'package:ecom_user_flutter/app/modules/auth/login/bindings/login_binding.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/register/binding/register_binding.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/views/login_view.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/register/view/register_view.dart';
import 'package:ecom_user_flutter/app/modules/cart/binding/cart_binding.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/cart_view.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/proceed_order.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/widgets/success_page.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/widgets/user_address.dart';
import 'package:ecom_user_flutter/app/modules/category/binding/category_binding.dart';
import 'package:ecom_user_flutter/app/modules/category/view/all_category_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/binding/delivery_binding.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/assigned_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/completed_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/deliveredOrder.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/my_delivery_tab.dart';

import 'package:ecom_user_flutter/app/modules/delivery/view/pending_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/order/binding/order_binding.dart';
import 'package:ecom_user_flutter/app/modules/order/view/order_details.dart';
import 'package:ecom_user_flutter/app/modules/products/binding/product_binding.dart';
import 'package:ecom_user_flutter/app/modules/products/view/brand_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/category_wised_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/product_detail.dart';
import 'package:ecom_user_flutter/app/modules/products/view/search_product_view.dart';
import 'package:ecom_user_flutter/app/modules/products/view/shop_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/today_deal_products.dart';
import 'package:ecom_user_flutter/app/modules/shop/binding/shop_binding.dart';
import 'package:ecom_user_flutter/app/modules/shop/view/brand_list_view.dart';
import 'package:ecom_user_flutter/app/modules/shop/view/shop_list.dart';
import 'package:ecom_user_flutter/app/modules/wishlist/binding/wishlist_binding.dart';
import 'package:ecom_user_flutter/app/modules/wishlist/view/wish_list_view.dart';


import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/order/view/order_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;
  // static const INITIAL = Routes.Test;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),


    GetPage(
      name: _Paths.ROOT,
      page: () => RootView(),
      binding: RootBinding(),
    ),
 GetPage(
      name: _Paths.BRAND_LIST,
      page: () => BrandListView(),
      binding: ShopBinding(),
    ),

    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
     GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: _Paths.SIGNUP,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),

GetPage(
      name: _Paths.ALL_DELIVERY_ORDER,
      page: () => AssignedAllDeliveryView(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.Completed_DELIVERY_ORDER,
      page: () => CompletedDeliveryView(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.Pending_DELIVERY_ORDER,
      page: () => PendingDeliveryView(status: 'assigned',),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => OrderDetailsView(),
      binding: OrderBinding(),
    ),
GetPage(
      name: _Paths.DELIVERED_ORDER,
      page: () => Deliveredorder(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.MY_DELIVERY,
      page: () => MyDeliveryTabView(),
      binding: DeliveryBinding(),
    ),

GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailPage(),
      binding: ProductBinding(),
    ),

    GetPage(
      name: _Paths.SHOP_PRODUCT,
      page: () => ShopProducts(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.BRAND_PRODUCT,
      page: () => BrandProducts(),
      binding: ProductBinding(),
    ),
GetPage(
      name: _Paths.TODAY_DEAL_PRODUCT,
      page: () => TodayDealProducts(),
      binding: ProductBinding(),
    ),

GetPage(
      name: _Paths.CART_VIEW,
      page: () => CartView(),
      binding: CartBinding(),
    ),
GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => UserAddress(),
      binding: CartBinding(),
    ),

GetPage(
      name: _Paths.PROCEED_ORDER,
      page: () => ProceedOrderPage(),
      binding: CartBinding(),
    ),
GetPage(
      name: _Paths.CHECKOUT_SUCCESS,
      page: () => CheckoutSuccessView(),
      binding: CartBinding(),
    ),
GetPage(
      name: _Paths.CATEGORY_VIEW,
      page: () => AllCategoryView(),
      binding: CategoryBinding(),
    ),
GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => OrderHistoryPage(),
      binding: OrderBinding(),
    ),


GetPage(
      name: _Paths.PRODUCT_FILTER,
      page: () => ProductFilterPage(),
      binding: ProductBinding(),
    ),

GetPage(
      name: _Paths.CATEGORY_WISE_PRODUCT,
      page: () => CategoryWisedProducts(),
      binding: ProductBinding(),
    ),
GetPage(
      name: _Paths.SHOP_LIST,
      page: () => ShopListView(),
      binding: ShopBinding(),
    ),

GetPage(
      name: _Paths.BRAND_LIST,
      page: () => BrandListView(),
      binding: ShopBinding(),
    ),

GetPage(
      name: _Paths.WISH_LIST,
      page: () => WishListView(),
      binding: WishlistBinding(),
    ),








  ];
}
