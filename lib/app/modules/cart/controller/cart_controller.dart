// lib/app/modules/cart/controller/cart_controller.dart
//
// Fixed CartController for your CartView + ProceedOrder flow.
//
// Key points:
// - Uses your existing fields: isLoading, error, selectedAddress, totalAmount, cart
// - Implements: getActiveCart, increaseQty, decreaseQty, removeItem
// - Implements: proceedToShipping() that returns a Map<String,String> payload
//   compatible with your repository checkout call (multipart form).
//
// Assumptions (adjust names if your repo differs):
// - OrderRepository().getCart() returns the Active cart response you shared.
// - OrderRepository().updateCartItemQty({required int itemId, required int qty})
// - OrderRepository().removeCartItem({required int itemId})
// - OrderRepository().checkout({required Map<String, String> data})
//
// If your repository function names differ, keep the controller logic and only change the repo calls.

import 'package:ecom_user_flutter/app/models/ecom/order/checkout_success.dart';
import 'package:ecom_user_flutter/app/models/ecom/order/user_address_model.dart';
import 'package:ecom_user_flutter/app/repositories/delivery_rep.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/models/ecom/order/cart_model.dart';
import 'package:ecom_user_flutter/app/repositories/order_rep.dart';
import 'package:velocity_x/velocity_x.dart';

class CartController extends GetxController {
  final isLoading = false.obs;
  final error = ''.obs;
  final selectedAddressIndex = 0.obs;
  // For checkout UI
  final isOutsideDhaka = 0.obs;
  final shippingCharge = 60.obs;
  final totalAmount = 0.0.obs;
  final mobileController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final areaController = TextEditingController().obs;
  final districtController = TextEditingController().obs;
  final isAddressAdding = false.obs;
  final  noteCtrl = TextEditingController().obs;
  final userAddress = <AddressModel>[].obs;
  final cart = Rxn<CartModel>();

  final OrderRepository _repo = OrderRepository();

  @override
  void onInit() {
    super.onInit();

    if(Get.find<AuthService>().currentUser.value.data != null){
      getCart();
      getUserAddress();
    }

  }
  @override
  void onClose() {

    mobileController.value.dispose();
    districtController.value.dispose();
    areaController.value.dispose();
    addressController.value.dispose();
   // noteCtrl.value.dispose();
    super.onClose();
  }
  // Initial load (active cart)
  Future<void> getCart() async {
    await getActiveCart(reset: true);
  }

  Future<void> getActiveCart({bool reset = false}) async {
    print("i am here 232");

    print("i am here 33");
    isLoading.value = true;
    error.value = '';

    try {
      final res = await _repo.getCart();

      if (res is Map && res['status'] == 'success') {
        final model = CartResModel.fromJson(res.cast<String, dynamic>());
        cart.value = model.data;
        print("i am here 23245");
        // sync totals for UI
        _recalcTotal();
      } else {
        cart.value = null;
        totalAmount.value = 0.0;
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      cart.value = null;
      totalAmount.value = 0.0;
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> increaseQty(CartItem item) async {
    if (isLoading.value) return;

    final currentQty = item.qty ?? 0;
    final nextQty = currentQty + 1;
    await _updateQty(item: item, nextQty: nextQty);
  }

  Future<void> decreaseQty(CartItem item) async {
    if (isLoading.value) return;

    final currentQty = item.qty ?? 0;
    final nextQty = currentQty - 1;

    if (nextQty <= 0) {
      await removeItem(item);
      return;
    }

    await _updateQty(item: item, nextQty: nextQty);
  }

  Future<void> removeItem(CartItem item) async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = '';

    try {
      final itemId = item.id;
      if (itemId == null) {
        error.value = 'Cart item id missing';
        return;
      }

      // repo call: DELETE /api/carts/items/delete/{itemId}
      final res = await _repo.removeCartItem(itemId: itemId.toString());

      if (res is Map && res['status'] == 'success') {
        // Optimistic local remove
        final c = cart.value;
        if (c != null) {
          final list = (c.items ?? <CartItem>[]);
          list.removeWhere((x) => x.id == itemId);

          // Update totals locally (or refetch cart)
          _recalcTotal();
          cart.refresh();
        } else {
          await getActiveCart(reset: true);
        }
      } else {
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  dynamic get selectedAddress {
    final addresses = userAddress.value;

    if (addresses.isEmpty) return null;

    if (selectedAddressIndex.value < 0 ||
        selectedAddressIndex.value >= addresses.length) {
      selectedAddressIndex.value = 0;
    }

    return addresses[selectedAddressIndex.value];
  }

  void selectAddress(int index) {
    final addresses = userAddress.value;

    if (index < 0 || index >= addresses.length) return;

    selectedAddressIndex.value = index;
  }
  Future<void> getUserAddress() async {
    print('i am here3423');

    isLoading.value = true;
    error.value = '';

    try {
      final res = await OrderRepository().getUserAddress();
      // Debug
      // print('Category API res = $res');

      if (res is Map && res['status'] == 'success') {
        final model = AddressResponse.fromJson(res as Map<String, dynamic>);
        userAddress.value = model.data!;
        if (userAddress.value.isNotEmpty &&
            selectedAddressIndex.value >= userAddress.value.length) {
          selectedAddressIndex.value = 0;
        }
        print('i am here3456523');
      } else {
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
 Future<void> deleteUserAddress(id) async {



      final res = await OrderRepository().deleteUserAddress(id);
      // Debug
      // print('Category API res = $res');

      if (res is Map && res['status'] == 'success') {

        print('i am 65456 success 34');

        getUserAddress();
      } else {
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }



  }

  void clearAddressForm() {
    mobileController.value.clear();
    districtController.value.clear();
    areaController.value.clear();
    addressController.value.clear();
  }

  bool validateAddressForm() {
    if (mobileController.value.text.trim().isEmpty) {
      Get.snackbar('Required', 'Mobile number is required');
      return false;
    }

    if (districtController.value.text.trim().isEmpty) {
      Get.snackbar('Required', 'District is required');
      return false;
    }

    if (areaController.value.text.trim().isEmpty) {
      Get.snackbar('Required', 'Area is required');
      return false;
    }

    if (addressController.value.text.trim().isEmpty) {
      Get.snackbar('Required', 'Address is required');
      return false;
    }

    return true;
  }
  Future<void> addAddressController() async {
    if (!validateAddressForm()) return;
    if (isAddressAdding.value) return;

    isAddressAdding.value = true;
    error.value = '';

    final user = Get.find<AuthService>().currentUser.value.data?.user;

    if (user == null) {
      isAddressAdding.value = false;
      Get.snackbar('Error', 'User not found');
      return;
    }

    final Map data = {
      'user_id': user.id.toString(),
      'name': user.name.toString(),
      'mobile': mobileController.value.text.trim(),
      'division': districtController.value.text.trim(),
      'district': districtController.value.text.trim(),
      'area': areaController.value.text.trim(),
      'address': addressController.value.text.trim(),
    };

    try {
      final res = await DeliveryRepository().addAddress(data);

      if (res is Map && res['status'] == 'success') {
        clearAddressForm();
        Get.back();

        Get.snackbar(
          'Success',
          res['message']?.toString() ?? 'Address added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Call your address refresh API here.
        // Example:
         await getUserAddress();
      } else {
        error.value = res is Map
            ? (res['message']?.toString() ?? 'Failed')
            : 'Failed';

        Get.snackbar(
          'Error',
          error.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddressAdding.value = false;
    }
  }

  Future<void> _updateQty(
      {required CartItem item, required int nextQty}) async {
    isLoading.value = true;
    error.value = '';

    try {
      final itemId = item.id;
      if (itemId == null) {
        error.value = 'Cart item id missing';
        return;
      }

      // repo call: PUT /api/carts/items/update/{itemId} with qty
      final res =
          await _repo.updateCartItemQuantity(itemId: itemId, qty: nextQty);

      if (res['status'] == 'success') {
        // Option A: refetch active cart to ensure totals are correct from server
        await getActiveCart(reset: true);

        print("i am here 56645");

        // Option B (optimistic) could be done, but refetch is safer for totals.
      } else {
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _recalcTotal() {
    final c = cart.value;
    if (c == null) {
      totalAmount.value = 0.0;
      return;
    }

    // Your API returns subtotal as number (sometimes int).
    // Use line_total sum as a fallback.
    final sub = c.subtotal;
    if (sub != null) {
      totalAmount.value = sub.toDouble();
      return;
    }

    final items = c.items ?? <CartItem>[];
    double sum = 0.0;
    for (final it in items) {
      final lt = it.lineTotal;
      if (lt != null) sum += lt.toDouble();
    }
    totalAmount.value = sum;
  }

  // ------------------------------------------------------------
  // Checkout payload builder + repository call hook
  // ------------------------------------------------------------

  /// Builds payload map for checkout API (multipart form):
  /// --form 'user_id="1"'
  /// --form 'customer_name="4"'
  /// --form 'customer_phone="1"'
  /// --form 'shipping_address="dfsdds"'
  /// --form 'zone="dfssfd"'
  /// --form 'note="dsfsd"'
  ///
  /// You can call this in UI (ProceedOrder page) and pass real address data.
  Map<String, String> buildCheckoutPayload({
    required String userId,
    required String customerName,
    required String customerPhone,
    required String shippingAddress,
    required String zone,
    required String isOutsideDhaka,
    String note = '',
  }) {
    return <String, String>{
      'user_id': userId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'shipping_address': shippingAddress,
      'zone': zone,
      'note': note,
      'is_outside_dhaka': isOutsideDhaka,
    };
  }

  /// Uses selected address string + customer info to create payload and call checkout.
  /// Pass values from your Address selection UI.
  ///
  /// Example usage from ProceedOrderPage:
  /// controller.proceedToShipping(
  ///   userId: userIdFromAuth,
  ///   customerName: selectedAddress.name,
  ///   customerPhone: selectedAddress.mobile,
  ///   shippingAddress: selectedAddress.address,
  ///   zone: selectedAddress.district ?? '',
  ///   note: noteText,
  /// );
  ///
  goToCheckout() {
    Get.toNamed(Routes.PROCEED_ORDER);
  }

  Future<void> proceedToShipping({
    String note = '',
  }) async {
    if (isLoading.value) return;

    // Basic guards
    final c = cart.value;
    if (c == null || (c.items ?? <CartItem>[]).isEmpty) {
      Get.snackbar('Cart', 'Your cart is empty');
      return;
    }

    final payload = buildCheckoutPayload(
      userId:
          Get.find<AuthService>().currentUser.value.data!.user!.id.toString(),
      customerName:
          Get.find<AuthService>().currentUser.value.data!.user!.name.toString(),
      customerPhone: selectedAddress.mobile.toString(),
      shippingAddress:  selectedAddress.address?.toString() ?? 'No address details',
      zone: 'zone',
      note: noteCtrl.value.text.isEmpty ? 'No Note' : noteCtrl.value.text ,
      isOutsideDhaka: isOutsideDhaka.value.toString(),
    );

    isLoading.value = true;
    error.value = '';


      final res = await _repo.checkout(payload); // implement in repo

      if (res is Map && res['status'] == 'success') {
        // After successful checkout, refresh cart
       await getActiveCart(reset: true);

        print("i am here 4554 $res");
       final checkoutResponse = CheckoutSuccessResponse.fromJson(
         Map<String, dynamic>.from(res),
       );

       Get.offNamed(
         Routes.CHECKOUT_SUCCESS,
         arguments: checkoutResponse,
       );
        // Navigate if you want:
        Get.offNamed(Routes.CHECKOUT_SUCCESS, arguments: {
          'order_id': res['data'][0]['order_number'],
          'amount': res['data'][0]['total'].toString(),
        });
      }
      else {
        print("i am here 4554 ");
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
        Get.snackbar('Order', error.value);
      }

  }
}
