import 'dart:async';
import 'dart:math';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final StreamController<Order> _newOrderController =
      StreamController<Order>.broadcast();
  Stream<Order> get newOrderStream => _newOrderController.stream;

  List<Order> _pendingOrders = [];
  List<Order> _completedOrders = [];

  // สุ่มงานใหม่เมื่อ Rider ออนไลน์
  Timer? _orderGeneratorTimer;

  void startReceivingOrders() {
    _orderGeneratorTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (Random().nextBool()) {
        // 50% chance ของการมีงานใหม่
        _generateRandomOrder();
      }
    });
  }

  void stopReceivingOrders() {
    _orderGeneratorTimer?.cancel();
    _orderGeneratorTimer = null;
  }

  void _generateRandomOrder() {
    final random = Random();
    final orderId = 'ORD${1000 + random.nextInt(9000)}';

    final pickupLocations = [
      {'name': 'McDonald\'s สีลม', 'lat': 13.7307, 'lng': 100.5418},
      {'name': 'KFC เซ็นทรัลเวิลด์', 'lat': 13.7472, 'lng': 100.5398},
      {'name': 'Starbucks สยาม', 'lat': 13.7460, 'lng': 100.5341},
      {'name': 'Pizza Hut อโศก', 'lat': 13.7372, 'lng': 100.5600},
    ];

    final deliveryLocations = [
      {'name': 'อาคาร Thai Summit', 'lat': 13.7270, 'lng': 100.5435},
      {'name': 'สำนักงาน CP Tower', 'lat': 13.7414, 'lng': 100.5369},
      {'name': 'คอนโด The Address Sathorn', 'lat': 13.7198, 'lng': 100.5280},
      {'name': 'โรงแรม Centara Grand', 'lat': 13.7439, 'lng': 100.5339},
    ];

    final pickup = pickupLocations[random.nextInt(pickupLocations.length)];
    final delivery =
        deliveryLocations[random.nextInt(deliveryLocations.length)];

    final order = Order(
      id: orderId,
      customerName: 'ลูกค้า ${random.nextInt(999) + 1}',
      pickupLocation: Location(
        name: pickup['name']! as String,
        address: pickup['name']! as String,
        latitude: pickup['lat']! as double,
        longitude: pickup['lng']! as double,
      ),
      deliveryLocation: Location(
        name: delivery['name']! as String,
        address: delivery['name']! as String,
        latitude: delivery['lat']! as double,
        longitude: delivery['lng']! as double,
      ),
      items: ['อาหาร ${random.nextInt(5) + 1} รายการ'],
      fee: 40 + random.nextInt(60).toDouble(), // 40-100 บาท
      distance: (1 + random.nextInt(8)).toDouble(), // 1-9 km
      estimatedTime: 15 + random.nextInt(30), // 15-45 นาที
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    _pendingOrders.add(order);
    _newOrderController.add(order);
  }

  List<Order> getPendingOrders() => List.from(_pendingOrders);
  List<Order> getCompletedOrders() => List.from(_completedOrders);

  void acceptOrder(String orderId) {
    final index = _pendingOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _pendingOrders[index] = _pendingOrders[index].copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );
    }
  }

  void startDelivery(String orderId) {
    final index = _pendingOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _pendingOrders[index] = _pendingOrders[index].copyWith(
        status: OrderStatus.inProgress,
        startedAt: DateTime.now(),
      );
    }
  }

  void completeOrder(String orderId) {
    final index = _pendingOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _pendingOrders[index].copyWith(
        status: OrderStatus.completed,
        completedAt: DateTime.now(),
      );
      _pendingOrders.removeAt(index);
      _completedOrders.insert(0, order);
    }
  }

  void rejectOrder(String orderId) {
    _pendingOrders.removeWhere((order) => order.id == orderId);
  }

  void dispose() {
    _orderGeneratorTimer?.cancel();
    _newOrderController.close();
  }
}

class Order {
  final String id;
  final String customerName;
  final Location pickupLocation;
  final Location deliveryLocation;
  final List<String> items;
  final double fee;
  final double distance;
  final int estimatedTime;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Order({
    required this.id,
    required this.customerName,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.items,
    required this.fee,
    required this.distance,
    required this.estimatedTime,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
  });

  Order copyWith({
    String? id,
    String? customerName,
    Location? pickupLocation,
    Location? deliveryLocation,
    List<String>? items,
    double? fee,
    double? distance,
    int? estimatedTime,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      items: items ?? this.items,
      fee: fee ?? this.fee,
      distance: distance ?? this.distance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class Location {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

enum OrderStatus { pending, accepted, inProgress, completed, cancelled }
