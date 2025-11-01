import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as LocationService;
import '../../services/order_service.dart';
import 'dart:async';
import 'dart:math';

class NavigationScreen extends StatefulWidget {
  final Order order;
  final Location destination;
  final String destinationType; // 'pickup' or 'delivery'

  const NavigationScreen({
    super.key,
    required this.order,
    required this.destination,
    required this.destinationType,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  LocationService.Location _locationService = LocationService.Location();
  StreamSubscription<LocationService.LocationData>? _locationSubscription;
  LocationService.LocationData? _currentLocation;

  double _distanceToDestination = 0.0;
  double _estimatedTime = 0.0;
  bool _isNavigating = false;
  String _status = 'เตรียมพร้อม';

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeNavigation() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    _startLocationTracking();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }

    LocationService.PermissionStatus permissionGranted =
        await _locationService.hasPermission();
    if (permissionGranted == LocationService.PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await _locationService.getLocation();
      setState(() {
        _currentLocation = location;
        _updateDistance();
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _startLocationTracking() {
    _locationSubscription = _locationService.onLocationChanged.listen((
      location,
    ) {
      setState(() {
        _currentLocation = location;
        _updateDistance();
      });
    });
  }

  void _updateDistance() {
    if (_currentLocation != null) {
      final distance = _calculateDistance(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
        widget.destination.latitude,
        widget.destination.longitude,
      );

      setState(() {
        _distanceToDestination = distance;
        _estimatedTime = distance / 30 * 60; // สมมติความเร็ว 30 กม./ชม.

        if (distance < 0.1) {
          // ถ้าอยู่ห่างน้อยกว่า 100 เมตร
          _status = 'มาถึงจุดหมายแล้ว';
        } else if (_isNavigating) {
          _status = 'กำลังนำทาง';
        }
      });
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371; // รัศมีโลกในกิโลเมตร
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  void _startNavigation() {
    setState(() {
      _isNavigating = true;
      _status = 'กำลังนำทาง';
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'เริ่มนำทางไป${widget.destinationType == 'pickup' ? 'จุดรับสินค้า' : 'จุดส่งสินค้า'}',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openGoogleMaps() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.destination.latitude},${widget.destination.longitude}&travelmode=driving';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showError('ไม่สามารถเปิด Google Maps ได้');
    }
  }

  void _openAppleMaps() async {
    final url =
        'http://maps.apple.com/?daddr=${widget.destination.latitude},${widget.destination.longitude}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showError('ไม่สามารถเปิด Apple Maps ได้');
    }
  }

  void _openWaze() async {
    final url =
        'https://waze.com/ul?ll=${widget.destination.latitude},${widget.destination.longitude}&navigate=yes';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showError('ไม่สามารถเปิด Waze ได้');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _completeNavigation() {
    Navigator.pop(
      context,
      true,
    ); // ส่งค่า true กลับไปเพื่อบอกว่าการนำทางเสร็จแล้ว
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.destinationType == 'pickup'
              ? 'นำทางไปรับสินค้า'
              : 'นำทางไปส่งสินค้า',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Status Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _distanceToDestination < 0.1 ? Icons.place : Icons.navigation,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  _status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_currentLocation != null) ...[
                  Text(
                    '${_distanceToDestination.toStringAsFixed(1)} กม. • ${_estimatedTime.toStringAsFixed(0)} นาที',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ],
            ),
          ),

          // Destination Info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            widget.destinationType == 'pickup'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.destinationType == 'pickup'
                            ? Icons.store
                            : Icons.location_on,
                        color:
                            widget.destinationType == 'pickup'
                                ? Colors.green
                                : Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.destinationType == 'pickup'
                                ? 'จุดรับสินค้า'
                                : 'จุดส่งสินค้า',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  widget.destinationType == 'pickup'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.destination.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.destination.address,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Navigation Options
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เลือกแอปนำทาง',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Google Maps
                  _buildNavigationOption(
                    'Google Maps',
                    'นำทางด้วย Google Maps',
                    Icons.map,
                    Colors.blue,
                    _openGoogleMaps,
                  ),

                  const SizedBox(height: 12),

                  // Apple Maps
                  _buildNavigationOption(
                    'Apple Maps',
                    'นำทางด้วย Apple Maps',
                    Icons.apple,
                    Colors.grey.shade700,
                    _openAppleMaps,
                  ),

                  const SizedBox(height: 12),

                  // Waze
                  _buildNavigationOption(
                    'Waze',
                    'นำทางด้วย Waze',
                    Icons.traffic,
                    Colors.purple,
                    _openWaze,
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!_isNavigating)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startNavigation,
                      icon: const Icon(Icons.navigation, color: Colors.white),
                      label: const Text(
                        'เริ่มนำทาง',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                if (_isNavigating && _distanceToDestination < 0.1)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _completeNavigation,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        'มาถึงจุดหมายแล้ว',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('ยกเลิก'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
