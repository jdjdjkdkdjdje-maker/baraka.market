import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

// ============================================================
// BARAKA MARKET — Cart Provider (Riverpod)
// ============================================================

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final double? oldPrice;
  final int? discountPercent;
  final String? imageUrl;
  final String? emoji;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.oldPrice,
    this.discountPercent,
    this.imageUrl,
    this.emoji,
    this.quantity = 1,
  });

  double get total => price * quantity;
  double get savings => oldPrice != null ? (oldPrice! - price) * quantity : 0;

  CartItem copyWith({int? quantity}) => CartItem(
    id: id, productId: productId, productName: productName,
    price: price, oldPrice: oldPrice, discountPercent: discountPercent,
    imageUrl: imageUrl, emoji: emoji,
    quantity: quantity ?? this.quantity,
  );

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: product['nameUz'] as String? ?? '',
      price: double.tryParse(product['price']?.toString() ?? '0') ?? 0,
      oldPrice: product['oldPrice'] != null
          ? double.tryParse(product['oldPrice'].toString())
          : null,
      discountPercent: product['discountPercent'] as int?,
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;
  final String? couponCode;
  final double couponDiscount;
  final int bonusPointsToUse;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.couponCode,
    this.couponDiscount = 0,
    this.bonusPointsToUse = 0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get totalSavings => items.fold(0, (sum, item) => sum + item.savings);
  double get deliveryFee => subtotal >= 100000 ? 0 : 15000;
  double get discount => couponDiscount + bonusPointsToUse * 10;
  double get total => (subtotal - discount + deliveryFee).clamp(0, double.infinity);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get hasFreeDelivery => subtotal >= 100000;
  double get amountForFreeDelivery => (100000 - subtotal).clamp(0, double.infinity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    String? couponCode,
    double? couponDiscount,
    int? bonusPointsToUse,
  }) =>
      CartState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        couponCode: couponCode ?? this.couponCode,
        couponDiscount: couponDiscount ?? this.couponDiscount,
        bonusPointsToUse: bonusPointsToUse ?? this.bonusPointsToUse,
      );
}

class CartNotifier extends StateNotifier<CartState> {
  final DioClient _dio;

  CartNotifier(this._dio) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.instance.get('/cart');
      final items = (response.data['data']['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Add item to cart
  Future<void> addItem(String productId, {int quantity = 1}) async {
    // Optimistic update
    final existingIndex = state.items.indexWhere((i) => i.productId == productId);
    if (existingIndex >= 0) {
      final updated = [...state.items];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updated);
    }

    try {
      await _dio.instance.post('/cart/items', data: {'productId': productId, 'quantity': quantity});
      await _loadCart(); // Sync with server
    } catch (e) {
      await _loadCart(); // Revert on error
      rethrow;
    }
  }

  // Update quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(itemId);
      return;
    }

    // Optimistic update
    final updated = state.items.map((item) {
      if (item.id == itemId) return item.copyWith(quantity: quantity);
      return item;
    }).toList();
    state = state.copyWith(items: updated);

    try {
      await _dio.instance.put('/cart/items/$itemId', data: {'quantity': quantity});
    } catch (e) {
      await _loadCart();
      rethrow;
    }
  }

  // Remove item
  Future<void> removeItem(String itemId) async {
    // Optimistic update
    final updated = state.items.where((i) => i.id != itemId).toList();
    state = state.copyWith(items: updated);

    try {
      await _dio.instance.delete('/cart/items/$itemId');
    } catch (e) {
      await _loadCart();
      rethrow;
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    state = state.copyWith(items: []);
    try {
      await _dio.instance.delete('/cart/clear');
    } catch (_) {}
  }

  // Apply coupon
  Future<void> applyCoupon(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.instance.post('/cart/coupon', data: {
        'code': code,
        'subtotal': state.subtotal,
      });
      final discount = double.tryParse(
        response.data['data']['discount']?.toString() ?? '0',
      ) ?? 0;
      state = state.copyWith(
        couponCode: code,
        couponDiscount: discount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Kupon topilmadi yoki nofaol',
      );
      rethrow;
    }
  }

  // Remove coupon
  void removeCoupon() {
    state = state.copyWith(couponCode: null, couponDiscount: 0);
  }

  // Set bonus points
  void setBonusPoints(int points) {
    state = state.copyWith(bonusPointsToUse: points);
  }

  bool containsProduct(String productId) {
    return state.items.any((i) => i.productId == productId);
  }

  int getProductQuantity(String productId) {
    final item = state.items.firstWhere(
      (i) => i.productId == productId,
      orElse: () => CartItem(
        id: '', productId: '', productName: '', price: 0,
      ),
    );
    return item.quantity;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CartNotifier(dio);
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});
