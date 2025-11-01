import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as LocationService;
import '../../services/order_service.dart';
import '../orders/order_detail_screen.dart';

class FreeMapScreen extends StatefulWidget {
  const FreeMapScreen({super.key});

  @override
  State<FreeMapScreen> createState() => _FreeMapScreenState();
}

class _FreeMapScreenState extends State<FreeMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final OrderService _orderService = OrderService();
  LocationService.Location _locationService = LocationService.Location();

  LatLng _currentPosition = const LatLng(13.7563, 100.5018); // Default: Bangkok
  List<Order> _pendingOrders = [];
  List<Marker> _markers = [];

  bool _isLoading = true;
  bool _locationPermissionGranted = false;
  bool _isFollowingUser = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();
    _loadOrders();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    await _requestLocationPermission();
    if (_locationPermissionGranted) {
      await _getCurrentLocation();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationService.PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == LocationService.PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != LocationService.PermissionStatus.granted) {
        return;
      }
    }

    _locationPermissionGranted = true;
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationService.LocationData locationData =
          await _locationService.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });
        _mapController.move(_currentPosition, 15.0);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _loadOrders() {
    setState(() {
      _pendingOrders = _orderService.getPendingOrders();
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    List<Marker> newMarkers = [];

    // Add user location marker
    if (_locationPermissionGranted) {
      newMarkers.add(
        Marker(
          point: _currentPosition,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Add order markers
    for (var order in _pendingOrders) {
      // Pickup location marker
      newMarkers.add(
        Marker(
          point: LatLng(
            order.pickupLocation.latitude,
            order.pickupLocation.longitude,
          ),
          child: GestureDetector(
            onTap: () => _showOrderDetails(order),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.store, color: Colors.white, size: 20),
            ),
          ),
        ),
      );

      // Delivery location marker
      newMarkers.add(
        Marker(
          point: LatLng(
            order.deliveryLocation.latitude,
            order.deliveryLocation.longitude,
          ),
          child: GestureDetector(
            onTap: () => _showOrderDetails(order),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Order header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delivery_dining,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ออเดอร์ #${order.id.substring(0, 8)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '฿${order.fee.toStringAsFixed(0)} • ${order.distance} กม.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Pickup location
                _buildLocationCard(
                  'จุดรับสินค้า',
                  order.pickupLocation.name,
                  Icons.store,
                  Colors.green,
                  () => _focusOnLocation(
                    LatLng(
                      order.pickupLocation.latitude,
                      order.pickupLocation.longitude,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Delivery location
                _buildLocationCard(
                  'จุดส่งสินค้า',
                  order.deliveryLocation.name,
                  Icons.location_on,
                  Colors.red,
                  () => _focusOnLocation(
                    LatLng(
                      order.deliveryLocation.latitude,
                      order.deliveryLocation.longitude,
                    ),
                  ),
                ),

                const Spacer(),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text('ปิด'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'รับงาน',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildLocationCard(
    String title,
    String address,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(address, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Icon(Icons.my_location, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  void _focusOnLocation(LatLng location) {
    _mapController.move(location, 16.0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แผนที่ฟรี',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : Stack(
                children: [
                  // Map
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition,
                      initialZoom: 13.0,
                      minZoom: 8.0,
                      maxZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                        maxNativeZoom: 19,
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),

                  // Legend
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem('คุณ', Colors.blue),
                          _buildLegendItem('รับสินค้า', Colors.green),
                          _buildLegendItem('ส่งสินค้า', Colors.red),
                        ],
                      ),
                    ),
                  ),

                  // Order count
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'งาน: ${_pendingOrders.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Control buttons
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // My location button
                        FloatingActionButton(
                          heroTag: 'location',
                          onPressed:
                              _locationPermissionGranted
                                  ? _getCurrentLocation
                                  : null,
                          backgroundColor:
                              _isFollowingUser ? Colors.green : Colors.white,
                          child: Icon(
                            Icons.my_location,
                            color:
                                _isFollowingUser
                                    ? Colors.white
                                    : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Zoom in
                        FloatingActionButton(
                          heroTag: 'zoom_in',
                          mini: true,
                          onPressed: () {
                            final zoom = _mapController.camera.zoom + 1;
                            _mapController.move(
                              _mapController.camera.center,
                              zoom,
                            );
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.add, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),

                        // Zoom out
                        FloatingActionButton(
                          heroTag: 'zoom_out',
                          mini: true,
                          onPressed: () {
                            final zoom = _mapController.camera.zoom - 1;
                            _mapController.move(
                              _mapController.camera.center,
                              zoom,
                            );
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.remove, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // No location permission overlay
                  if (!_locationPermissionGranted)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_disabled,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ไม่มีการเข้าถึงตำแหน่ง',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                  Text(
                                    'อนุญาตการเข้าถึงตำแหน่งเพื่อแสดงตำแหน่งของคุณ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: _initializeLocation,
                              child: const Text('อนุญาต'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
