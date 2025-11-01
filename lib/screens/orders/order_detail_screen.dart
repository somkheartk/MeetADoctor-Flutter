import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/order_service.dart';
import '../navigation/navigation_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderService _orderService = OrderService();
  late Order _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  void _acceptOrder() {
    _orderService.acceptOrder(_currentOrder.id);
    setState(() {
      _currentOrder = _currentOrder.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('รับงานสำเร็จ!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startDelivery() {
    _orderService.startDelivery(_currentOrder.id);
    setState(() {
      _currentOrder = _currentOrder.copyWith(
        status: OrderStatus.inProgress,
        startedAt: DateTime.now(),
      );
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('เริ่มการส่งแล้ว!'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _completeOrder() {
    _orderService.completeOrder(_currentOrder.id);
    HapticFeedback.lightImpact();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('งานเสร็จสมบูรณ์!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rejectOrder() {
    _orderService.rejectOrder(_currentOrder.id);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ปฏิเสธงานแล้ว'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToLocation(Location location, String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NavigationScreen(
              order: _currentOrder,
              destination: location,
              destinationType: type,
            ),
      ),
    );

    // หากการนำทางเสร็จสิ้น ให้อัปเดตสถานะออเดอร์
    if (result == true &&
        type == 'pickup' &&
        _currentOrder.status == OrderStatus.accepted) {
      _startDelivery();
    } else if (result == true &&
        type == 'delivery' &&
        _currentOrder.status == OrderStatus.inProgress) {
      _completeOrder();
    }
  }

  Color _getStatusColor() {
    switch (_currentOrder.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.inProgress:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (_currentOrder.status) {
      case OrderStatus.pending:
        return 'รอการยืนยัน';
      case OrderStatus.accepted:
        return 'รับงานแล้ว';
      case OrderStatus.inProgress:
        return 'กำลังส่ง';
      case OrderStatus.completed:
        return 'เสร็จสิ้น';
      case OrderStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('งาน ${_currentOrder.id}'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _getStatusColor().withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _getStatusColor(),
                          ),
                        ),
                        Text(
                          'งาน ${_currentOrder.id}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '฿${_currentOrder.fee.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${_currentOrder.distance} กม.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Customer Info
            _buildInfoCard('ข้อมูลลูกค้า', Icons.person, Colors.blue, [
              _buildInfoRow('ชื่อ', _currentOrder.customerName),
              _buildInfoRow('รายการ', _currentOrder.items.join(', ')),
              _buildInfoRow(
                'เวลาที่สั่ง',
                _formatTime(_currentOrder.createdAt),
              ),
            ]),
            const SizedBox(height: 16),

            // Pickup Location
            _buildLocationCard(
              'จุดรับของ',
              _currentOrder.pickupLocation,
              Icons.store,
              Colors.orange,
              () => _navigateToLocation(_currentOrder.pickupLocation, 'pickup'),
            ),
            const SizedBox(height: 16),

            // Delivery Location
            _buildLocationCard(
              'จุดส่งของ',
              _currentOrder.deliveryLocation,
              Icons.location_on,
              Colors.red,
              () => _navigateToLocation(
                _currentOrder.deliveryLocation,
                'delivery',
              ),
            ),
            const SizedBox(height: 20),

            // Navigation Button
            if (_currentOrder.status == OrderStatus.accepted ||
                _currentOrder.status == OrderStatus.inProgress)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      () => _navigateToLocation(
                        _currentOrder.status == OrderStatus.accepted
                            ? _currentOrder.pickupLocation
                            : _currentOrder.deliveryLocation,
                        _currentOrder.status == OrderStatus.accepted
                            ? 'pickup'
                            : 'delivery',
                      ),
                  icon: const Icon(Icons.navigation),
                  label: Text(
                    _currentOrder.status == OrderStatus.accepted
                        ? 'นำทางไปรับของ'
                        : 'นำทางไปส่งของ',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    String title,
    Location location,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.map, color: Colors.grey.shade400, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  location.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location.address,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (_currentOrder.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _rejectOrder,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ปฏิเสธ',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _acceptOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('รับงาน'),
              ),
            ),
          ],
        );

      case OrderStatus.accepted:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startDelivery,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('เริ่มการส่ง'),
          ),
        );

      case OrderStatus.inProgress:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('งานเสร็จสิ้น'),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
