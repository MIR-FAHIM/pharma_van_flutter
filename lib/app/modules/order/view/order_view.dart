// lib/app/modules/order/views/order_history_page.dart

import 'package:ecom_user_flutter/app/models/ecom/order/order_history_model.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecom_user_flutter/app/modules/order/controller/order_controller.dart';

class OrderHistoryPage extends GetView<OrderController> {
  const OrderHistoryPage({super.key});

  static const Color _navy = Color(0xFF1F214C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Order History",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: controller.userOrderHistoryController,
          );
        }

        final items = controller.orderHistory.value ?? <OrderHistoryItem>[];
        if (items.isEmpty) return const _EmptyState();

        return RefreshIndicator(
          onRefresh: () async => controller.userOrderHistoryController(),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderCard(item: items[i]),
          ),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item});

  final OrderHistoryItem item;

  static const Color _navy = Color(0xFF1F214C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final status = (item.status ?? "").trim().toLowerCase();
    final payment = (item.paymentStatus ?? "").trim().toLowerCase();

    final statusUi = _statusChip(status);
    final payUi = _paymentChip(payment);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // TODO: route to order detail page
       Get.find<OrderController>().getOrderDetails(item.id.toString());
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row: order number + total
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.orderNumber ?? "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "৳${_money(item.total)}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: _navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // chips row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip(text: statusUi.$1, bg: statusUi.$2, fg: statusUi.$3),
                _Chip(text: payUi.$1, bg: payUi.$2, fg: payUi.$3),
              ],
            ),

            const SizedBox(height: 12),

            // info rows
            _InfoRow(
              icon: Icons.person_outline,
              label: "Customer",
              value: item.customerName ?? "-",
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: "Address",
              value: item.shippingAddress ?? "-",
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Date",
              value: _formatDate(item.createdAt),
            ),

            if ((item.note ?? "").trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  item.note!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (String, Color, Color) _statusChip(String status) {
    switch (status) {
      case 'completed':
        return ("Completed", const Color(0xFFE8F7EE), const Color(0xFF15803D));
      case 'delivered':
        return ("Delivered", const Color(0xFFEAF2FF), const Color(0xFF1D4ED8));
      case 'processing':
        return ("Processing", const Color(0xFFFFF6E6), const Color(0xFFB45309));
      case 'pending':
      default:
        return ("Pending", const Color(0xFFF3F4F6), const Color(0xFF374151));
    }
  }

  (String, Color, Color) _paymentChip(String payment) {
    switch (payment) {
      case 'paid':
        return ("Paid", const Color(0xFFE8F7EE), const Color(0xFF15803D));
      case 'unpaid':
      default:
        return ("Unpaid", const Color(0xFFFFE9E9), const Color(0xFFB91C1C));
    }
  }

  String _money(double? v) {
    final n = (v ?? 0).toDouble();
    if (n == n.roundToDouble()) return n.toInt().toString();
    return n.toStringAsFixed(2);
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) return "-";
    // keep simple (no intl dependency)
    // "2026-01-29T06:11:19.000000Z" -> "2026-01-29 06:11"
    final s = iso.replaceAll("T", " ");
    final cut = s.split(".").first;
    if (cut.length >= 16) return cut.substring(0, 16);
    return cut;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: (maxLines > 1) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.bg, required this.fg});

  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w900,
          fontSize: 12,
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
            Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            const Text(
              "No orders yet",
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            const Text(
              "Your orders will show here after checkout.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

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
              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
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
