
import 'package:ecom_user_flutter/app/models/ecom/order/checkout_success.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutSuccessView extends GetView<CartController> {
  const CheckoutSuccessView({super.key});

  static const Color _brand = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);
  static const Color _success = Color(0xFF16A34A);
  static const Color _yellow = Color(0xFFFEFF00);
  static const Color _bg = Color(0xFFF5F7FB);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkout = _readCheckoutResponse(Get.arguments);

    if (checkout == null || checkout.data!.isEmpty) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(theme),
        body: const _EmptyCheckoutState(),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SuccessSummaryCard(checkout: checkout),

              const SizedBox(height: 14),

              _CustomerDeliveryCard(order: checkout.data!.first),

              const SizedBox(height: 14),

              _GrandTotalCard(checkout: checkout),

              const SizedBox(height: 14),

              Text(
                "Order Details",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: _navy,
                ),
              ),

              const SizedBox(height: 10),

              ListView.separated(
                itemCount: checkout.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _OrderCard(
                    order: checkout.data![index],
                    orderIndex: index + 1,
                  );
                },
              ),

              const SizedBox(height: 16),

              _ActionButtons(),

              const SizedBox(height: 14),

              Text(
                "You will receive updates about your delivery shortly.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: _brand,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Order Placed",
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  CheckoutSuccessResponse? _readCheckoutResponse(dynamic args) {
    if (args is CheckoutSuccessResponse) {
      return args;
    }

    if (args is Map && args['checkout'] is Map) {
      return CheckoutSuccessResponse.fromJson(
        Map<String, dynamic>.from(args['checkout']),
      );
    }

    if (args is Map && args['data'] is List) {
      return CheckoutSuccessResponse.fromJson(
        Map<String, dynamic>.from(args),
      );
    }

    return null;
  }
}

class _SuccessSummaryCard extends StatelessWidget {
  const _SuccessSummaryCard({
    required this.checkout,
  });

  final CheckoutSuccessResponse checkout;

  static const Color _brand = Color(0xFF00509D);
  static const Color _success = Color(0xFF16A34A);
  static const Color _yellow = Color(0xFFFEFF00);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: _success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: _success,
              size: 56,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "Order Confirmed!",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF151738),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Thank you for your purchase. Your order has been placed successfully.",

            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MiniSummary(
                    label: "Total Orders",
                    value: checkout.totalOrders.toString(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 38,
                  color: _brand.withOpacity(0.18),
                ),
                Expanded(
                  child: _MiniSummary(
                    label: "Grand Total",
                    value: _money(checkout.grandTotal),
                    valueColor: _brand,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _brand,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Payment Status: Unpaid",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _yellow,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSummary extends StatelessWidget {
  const _MiniSummary({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF151738),
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class _CustomerDeliveryCard extends StatelessWidget {
  const _CustomerDeliveryCard({
    required this.order,
  });

  final CheckoutSuccessOrder order;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.location_on_outlined,
            title: "Delivery Information",
          ),
          const SizedBox(height: 10),
          _InfoRow(label: "Name", value: order.customerName),
          _InfoRow(label: "Phone", value: order.customerPhone),
          _InfoRow(label: "Address", value: order.shippingAddress),
          if (order.zone.isNotEmpty) _InfoRow(label: "Zone", value: order.zone),
          if (order.note.isNotEmpty) _InfoRow(label: "Note", value: order.note),
        ],
      ),
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  const _GrandTotalCard({
    required this.checkout,
  });

  final CheckoutSuccessResponse checkout;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.receipt_long_outlined,
            title: "Payment Summary",
          ),
          const SizedBox(height: 10),
          _InfoRow(label: "Subtotal", value: _money(checkout.grandSubtotal)),
          _InfoRow(
            label: "Shipping Fee",
            value: _money(checkout.grandShippingFee),
          ),
          _InfoRow(label: "Discount", value: _money(checkout.grandDiscount)),
          const Divider(height: 18),
          _InfoRow(
            label: "Grand Total",
            value: _money(checkout.grandTotal),
            isBold: true,
            valueColor: const Color(0xFF00509D),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.orderIndex,
  });

  final CheckoutSuccessOrder order;
  final int orderIndex;

  static const Color _brand = Color(0xFF00509D);
  static const Color _yellow = Color(0xFFFEFF00);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: _brand,
                child: Text(
                  orderIndex.toString(),
                  style: const TextStyle(
                    color: _yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF151738),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Order ID: ${order.id}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusChip(
                    text: order.status,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 5),
                  _StatusChip(
                    text: order.paymentStatus,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          ListView.separated(
            itemCount: order.items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = order.items[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: _brand,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF151738),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Qty ${item.qty} × ${_money(item.unitPrice)}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    _money(item.lineTotal),
                    style: const TextStyle(
                      color: _brand,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),

          const Divider(height: 20),

          _InfoRow(label: "Subtotal", value: _money(order.subtotal)),
          _InfoRow(label: "Shipping Fee", value: _money(order.shippingFee)),
          _InfoRow(label: "Discount", value: _money(order.discount)),
          _InfoRow(
            label: "Order Total",
            value: _money(order.total),
            isBold: true,
            valueColor: _brand,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00509D),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Get.offNamed(Routes.ORDER_HISTORY);
              },
              child: const Text(
                "View My Orders",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Get.offAllNamed(Routes.ROOT);
              },
              child: const Text(
                "Continue Shopping",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF151738),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  const _BaseCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 7),
            color: Colors.black.withOpacity(0.035),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF00509D),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF151738),
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = text.isEmpty ? 'N/A' : text.capitalizeFirst ?? text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.trim().isEmpty ? 'N/A' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Text(
              safeValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
                color: valueColor ?? const Color(0xFF151738),
                fontSize: isBold ? 13 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCheckoutState extends StatelessWidget {
  const _EmptyCheckoutState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Text(
          "Order information not found.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

String _money(num value) {
  if (value % 1 == 0) {
    return "৳${value.toInt()}";
  }

  return "৳${value.toStringAsFixed(2)}";
}