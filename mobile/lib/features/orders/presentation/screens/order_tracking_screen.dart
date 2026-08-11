import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

// ============================================================
// BARAKA MARKET — Order Tracking Screen (Real-time Map)
// WebSocket + Google Maps
// ============================================================

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  IO.Socket? _socket;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  LatLng? _courierLocation;
  LatLng? _destinationLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String _orderStatus = 'ON_THE_WAY';
  String? _courierName;
  String? _courierPhone;
  String? _vehicleType;
  DateTime? _estimatedAt;
  bool _isConnected = false;

  final _statusSteps = [
    _StatusStep(status: 'CONFIRMED', label: 'Tasdiqlandi', icon: '✅'),
    _StatusStep(status: 'PREPARING', label: 'Tayyorlanmoqda', icon: '👨‍🍳'),
    _StatusStep(status: 'PICKED_UP', label: 'Olib ketildi', icon: '📦'),
    _StatusStep(status: 'ON_THE_WAY', label: 'Yo\'lda', icon: '🚗'),
    _StatusStep(status: 'DELIVERED', label: 'Yetkazildi', icon: '🎉'),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _socket = IO.io(
      AppConstants.wsUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'ACCESS_TOKEN'}) // From secure storage
          .build(),
    );

    _socket!.onConnect((_) {
      setState(() => _isConnected = true);
      // Watch this order
      _socket!.emit('order:watch', {'orderId': widget.orderId});
    });

    _socket!.onDisconnect((_) => setState(() => _isConnected = false));

    _socket!.on('delivery:state', (data) {
      setState(() {
        _orderStatus = data['status'] ?? _orderStatus;
        _courierName = data['courier']?['name'];
        _courierPhone = data['courier']?['phone'];
        _vehicleType = data['courier']?['vehicleType'];
        if (data['currentLocation'] != null) {
          _courierLocation = LatLng(
            data['currentLocation']['lat'] as double,
            data['currentLocation']['lng'] as double,
          );
          _updateMarkers();
        }
      });
    });

    _socket!.on('delivery:location', (data) {
      final lat = data['latitude'] as double;
      final lng = data['longitude'] as double;
      setState(() {
        _courierLocation = LatLng(lat, lng);
        _updateMarkers();
      });

      // Animate camera
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    });

    _socket!.on('order:status', (data) {
      setState(() => _orderStatus = data['status'] ?? _orderStatus);
      if (data['status'] == 'DELIVERED') {
        _showDeliveredDialog();
      }
    });
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    if (_courierLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('courier'),
        position: _courierLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: _courierName ?? 'Kuryer'),
      ));
    }

    if (_destinationLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'Manzil'),
      ));
    }

    setState(() => _markers = markers);
  }

  void _showDeliveredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Buyurtma yetkazildi!',
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Xaridingiz uchun rahmat!\nBaraka Market bilan qulaylik!',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              child: const Text('Baholash →'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _socket?.emit('order:unwatch', {'orderId': widget.orderId});
    _socket?.disconnect();
    _socket?.dispose();
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  int get _currentStepIndex {
    final idx = _statusSteps.indexWhere((s) => s.status == _orderStatus);
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buyurtma kuzatuvi'),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected ? AppColors.success : AppColors.error,
                  ),
                ),
                Text(
                  _isConnected ? 'Ulangan' : 'Ulanmoqda...',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // ─── Google Map ────────────────────────────────
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // Set dark/light style
            },
            initialCameraPosition: CameraPosition(
              target: _courierLocation ??
                  LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ─── Bottom Panel ──────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(theme, isDark),
          ),

          // ─── Center Button ─────────────────────────────
          Positioned(
            bottom: 300,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                if (_courierLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_courierLocation!, 15),
                  );
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Status stepper
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatusStepper(theme),
                const SizedBox(height: 20),
                if (_courierName != null) _buildCourierCard(theme, isDark),
                const SizedBox(height: 16),
                _buildEtaCard(theme, isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildStatusStepper(ThemeData theme) {
    return Row(
      children: List.generate(_statusSteps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isDone = stepIndex < _currentStepIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isDone ? AppColors.primary : AppColors.outline,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isDone = stepIndex <= _currentStepIndex;
        final isCurrent = stepIndex == _currentStepIndex;
        return Column(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: isCurrent ? _pulseAnimation.value : 1.0,
                child: child,
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.primary : AppColors.outline,
                  border: isCurrent
                      ? Border.all(color: AppColors.primaryLight, width: 3)
                      : null,
                ),
                child: Center(
                  child: Text(
                    _statusSteps[stepIndex].icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _statusSteps[stepIndex].label,
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 9,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                color: isDone ? AppColors.primary : AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCourierCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
            ),
            child: Center(
              child: Text(
                _vehicleType == 'BICYCLE' ? '🚴' : '🚗',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _courierName ?? 'Kuryer',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Kuryer',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (_courierPhone != null)
            Row(
              children: [
                _ActionButton(
                  icon: Icons.phone_rounded,
                  color: AppColors.success,
                  onTap: () {
                    // launch phone
                  },
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.message_rounded,
                  color: AppColors.info,
                  onTap: () {},
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEtaCard(ThemeData theme, bool isDark) {
    final eta = _estimatedAt != null
        ? _estimatedAt!.difference(DateTime.now())
        : const Duration(minutes: 15);
    final etaText = eta.isNegative
        ? 'Har qanday payt...'
        : '${eta.inMinutes} daqiqa qoldi';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(
            'Taxminiy vaqt: ',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark),
          ),
          Text(
            etaText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStep {
  final String status;
  final String label;
  final String icon;
  const _StatusStep({required this.status, required this.label, required this.icon});
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
