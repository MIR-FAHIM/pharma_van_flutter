// lib/app/modules/order/views/proceed_order_page.dart

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/order/cart_model.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/widgets/selected_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProceedOrderPage extends StatefulWidget {
  const ProceedOrderPage({super.key});

  @override
  State<ProceedOrderPage> createState() => _ProceedOrderPageState();
}

class _ProceedOrderPageState extends State<ProceedOrderPage> {
  final CartController controller = Get.find<CartController>();
  final TextEditingController couponCtrl = TextEditingController();

  String selectedPayment = 'cod';
  int isOutsideDhaka = 0;

  int get shippingCharge => isOutsideDhaka == 1 ? 60 : 30;
  num get payableTotal => controller.totalAmount.value + shippingCharge;

  static const Color _navy = Color(0xFF1F214C);
  static const Color _bg = Color(0xFFF7F8FA);
  static const Color _softBeige = Color(0xFFFFF3DF);
  static const Color _line = Color(0xFFE9EAF0);

  @override
  void dispose() {
    couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Checkout',
          style: theme.textTheme.titleMedium?.copyWith(
            color: _navy,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final cart = controller.cart.value;
        final items = cart?.items ?? const <CartItem>[];
        final hasItems = items.isNotEmpty;

        return _CheckoutBottomBar(
          couponCtrl: couponCtrl,
          total: payableTotal,
          enabled: hasItems,
          onApplyCoupon: _applyCoupon,
          onDetails: () => _showTotalDetailsBottomSheet(
            context,
            totalItems: items.length,
            subtotal: controller.totalAmount.value,
            shippingCharge: shippingCharge,
            total: payableTotal,
          ),
          onPlaceOrder: () => _placeOrder(cart),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _PageLoader();
        }

        final cart = controller.cart.value;
        final items = cart?.items ?? const <CartItem>[];

        return RefreshIndicator(
          onRefresh: () async {
            controller.getActiveCart(reset: true);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                sliver: const SliverToBoxAdapter(child: _CheckoutProgress()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                sliver: const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Delivery address'),
                ),
              ),
              const SliverToBoxAdapter(child: SelectedAddress()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Delivery area'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: _DeliveryAreaCard(
                    isOutsideDhaka: isOutsideDhaka,
                    onChanged: (value) {
                      setState(() {
                        isOutsideDhaka = value;
                      });
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Items',
                    trailing: '${items.length} item${items.length == 1 ? '' : 's'}',
                  ),
                ),
              ),
              if (items.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                  sliver: SliverToBoxAdapter(child: _EmptyItemsCard()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index.isOdd) return const SizedBox(height: 12);
                        final itemIndex = index ~/ 2;
                        final item = items[itemIndex];
                        return _CheckoutCartItemCard(
                          key: ValueKey(_itemKey(item, itemIndex)),
                          item: item,
                          index: itemIndex,
                        );
                      },
                      childCount: items.length * 2 - 1,
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                sliver: const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Order note'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: _OrderNoteCard(controller: controller.noteCtrl.value),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                sliver: const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Payment Method'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                sliver: SliverToBoxAdapter(
                  child: _PaymentMethodCard(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when you receive your order',
                    isSelected: selectedPayment == 'cod',
                    onTap: () => setState(() => selectedPayment = 'cod'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _applyCoupon() {
    FocusScope.of(context).unfocus();
    final coupon = couponCtrl.text.trim();

    if (coupon.isEmpty) {
      Get.snackbar(
        'Coupon',
        'Please enter a coupon code first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Coupon',
      'Coupon apply API is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _placeOrder(CartModel? cart) {
    final items = cart?.items ?? const <CartItem>[];

    if (!_hasSelectedAddress()) {
      Get.snackbar(
        'Address Required',
        'Please add or select a delivery address first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (items.isEmpty) {
      Get.snackbar(
        'Cart',
        'Your cart is empty.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.isOutsideDhaka.value = isOutsideDhaka;
    controller.shippingCharge.value = shippingCharge;
    controller.proceedToShipping();
  }

  bool _hasSelectedAddress() {
    final dynamic selected = controller.selectedAddress;

    try {
      return selected.value != null;
    } catch (_) {
      return selected != null;
    }
  }

  void _showTotalDetailsBottomSheet(
      BuildContext context, {
        required int totalItems,
        required num subtotal,
        required num shippingCharge,
        required num total,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total details',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                  ),
                ),
                const SizedBox(height: 14),
                _KeyValueRow(label: 'Items', value: '$totalItems'),
                const SizedBox(height: 10),
                _KeyValueRow(label: 'Subtotal', value: _money(subtotal)),
                const SizedBox(height: 10),
                _KeyValueRow(label: 'Shipping charge', value: _money(shippingCharge)),
                const SizedBox(height: 10),
                const Divider(height: 18),
                _KeyValueRow(label: 'Total', value: _money(total), strong: true),
              ],
            ),
          ),
        );
      },
    );
  }
}
class _OrderNoteCard extends StatelessWidget {
  const _OrderNoteCard({required this.controller});

  final TextEditingController controller;

  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        minLines: 3,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(
          hintText: 'Write order note here',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _DeliveryAreaCard extends StatelessWidget {
  const _DeliveryAreaCard({
    required this.isOutsideDhaka,
    required this.onChanged,
  });

  final int isOutsideDhaka;
  final ValueChanged<int> onChanged;

  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
      child: Column(
        children: [
          _AreaOption(
            title: 'Next Day Delivery',
            subtitle: 'Shipping charge ৳30',
            selected: isOutsideDhaka == 0,
            onTap: () => onChanged(0),
          ),
          const Divider(height: 14),
          _AreaOption(
            title: 'Same Day Delivery',
            subtitle: 'Shipping charge ৳60',
            selected: isOutsideDhaka == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _AreaOption extends StatelessWidget {
  const _AreaOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _softBeige : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? _navy : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutProgress extends StatelessWidget {
  const _CheckoutProgress();

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;
  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        children: const [
          _StepBubble(icon: Icons.shopping_cart_checkout_rounded, label: 'Cart', done: true),
          Expanded(child: _StepLine()),
          _StepBubble(icon: Icons.location_on_outlined, label: 'Checkout', done: true),
          Expanded(child: _StepLine(active: false)),
          _StepBubble(icon: Icons.check_circle_outline_rounded, label: 'Confirm', done: false),
        ],
      ),
    );
  }
}

class _StepBubble extends StatelessWidget {
  const _StepBubble({required this.icon, required this.label, required this.done});

  final IconData icon;
  final String label;
  final bool done;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: done ? _navy : _softBeige,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: done ? Colors.white : _navy, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: done ? _navy : Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({this.active = true});

  final bool active;

  static const Color _navy = _ProceedOrderPageState._navy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20, left: 6, right: 6),
      decoration: BoxDecoration(
        color: active ? _navy.withOpacity(0.5) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black45,
            ),
          ),
      ],
    );
  }
}

class _CheckoutCartItemCard extends StatelessWidget {
  const _CheckoutCartItemCard({super.key, required this.item, required this.index});

  final CartItem item;
  final int index;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = item.product;
    final title = product?.name ?? 'Product';
    final price = item.unitPrice ?? product?.unitPrice ?? 0;
    final qty = item.qty ?? 0;
    final imgUrl = _asImageUrl(product?.primaryImage?.fileName);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: _heroTag(item, index),
            child: _ProductImage(url: imgUrl, size: 74),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyChip(qty: qty),
                    const Spacer(),
                    Text(
                      _money(price),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _navy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyChip extends StatelessWidget {
  const _QtyChip({required this.qty});

  final int qty;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _softBeige,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Box $qty',
        style: const TextStyle(
          color: _navy,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _line = _ProceedOrderPageState._line;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? _navy : _line, width: isSelected ? 1.4 : 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.045),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 46,
              decoration: BoxDecoration(
                color: _softBeige,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.local_shipping_outlined, color: _navy),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                key: ValueKey(isSelected),
                color: isSelected ? Colors.green : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({
    required this.couponCtrl,
    required this.total,
    required this.enabled,
    required this.onApplyCoupon,
    required this.onDetails,
    required this.onPlaceOrder,
  });

  final TextEditingController couponCtrl;
  final num total;
  final bool enabled;
  final VoidCallback onApplyCoupon;
  final VoidCallback onDetails;
  final VoidCallback onPlaceOrder;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _softBeige = _ProceedOrderPageState._softBeige;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, -8),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CouponRow(controller: couponCtrl, onApply: onApplyCoupon),
            const SizedBox(height: 10),
            InkWell(
              onTap: onDetails,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _softBeige,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      'Total Amount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black45, size: 20),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: Text(
                        _money(total),
                        key: ValueKey(total),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: _navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _navy,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: enabled ? onPlaceOrder : null,
                child: const Text(
                  'PLACE MY ORDER',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponRow extends StatelessWidget {
  const _CouponRow({required this.controller, required this.onApply});

  final TextEditingController controller;
  final VoidCallback onApply;

  static const Color _navy = _ProceedOrderPageState._navy;
  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.confirmation_number_outlined, size: 20, color: Colors.black45),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Enter coupon code',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                ),
                onPressed: onApply,
                child: const Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  static const Color _navy = _ProceedOrderPageState._navy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? Colors.black87 : Colors.black54,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: strong ? _navy : Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey.shade100,
        child: url.isEmpty
            ? const Icon(Icons.image_outlined, color: Colors.black38, size: 30)
            : Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
            color: Colors.black38,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class _EmptyItemsCard extends StatelessWidget {
  const _EmptyItemsCard();

  static const Color _line = _ProceedOrderPageState._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: const Text(
        'No items in cart',
        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black54),
      ),
    );
  }
}

class _PageLoader extends StatelessWidget {
  const _PageLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

String _money(num? value) {
  return '৳${(value ?? 0).toStringAsFixed(2)}';
}

String _asImageUrl(String? fileName) {
  if (fileName == null || fileName.trim().isEmpty) return '';
  if (fileName.startsWith('http')) return fileName;
  return '${CompanyData.image_file_url}/$fileName';
}

String _heroTag(CartItem item, int index) {
  final product = item.product;
  final raw = product?.primaryImage?.fileName ?? product?.name ?? index.toString();
  return 'cart_product_image_$raw';
}

String _itemKey(CartItem item, int index) {
  final product = item.product;
  return product?.primaryImage?.fileName ?? product?.name ?? index.toString();
}
