import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

// ============================================================
// BARAKA MARKET — Product Providers (Riverpod)
// ============================================================

// ─── Product Filter State ─────────────────────────────────
class ProductFilter {
  final String? search;
  final String? categoryId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String sortBy;
  final String sortOrder;
  final bool? isFeatured;
  final bool? isNew;
  final bool? isOrganic;
  final double? minRating;
  final int page;
  final int limit;

  const ProductFilter({
    this.search,
    this.categoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'createdAt',
    this.sortOrder = 'desc',
    this.isFeatured,
    this.isNew,
    this.isOrganic,
    this.minRating,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParams() => {
    if (search != null) 'search': search,
    if (categoryId != null) 'categoryId': categoryId,
    if (brandId != null) 'brandId': brandId,
    if (minPrice != null) 'minPrice': minPrice,
    if (maxPrice != null) 'maxPrice': maxPrice,
    'sortBy': sortBy,
    'sortOrder': sortOrder,
    if (isFeatured != null) 'isFeatured': isFeatured,
    if (isNew != null) 'isNew': isNew,
    if (isOrganic != null) 'isOrganic': isOrganic,
    if (minRating != null) 'rating': minRating,
    'page': page,
    'limit': limit,
  };

  ProductFilter copyWith({
    String? search,
    String? categoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
    bool? isFeatured,
    bool? isNew,
    bool? isOrganic,
    double? minRating,
    int? page,
    int? limit,
  }) =>
      ProductFilter(
        search: search ?? this.search,
        categoryId: categoryId ?? this.categoryId,
        brandId: brandId ?? this.brandId,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        sortBy: sortBy ?? this.sortBy,
        sortOrder: sortOrder ?? this.sortOrder,
        isFeatured: isFeatured ?? this.isFeatured,
        isNew: isNew ?? this.isNew,
        isOrganic: isOrganic ?? this.isOrganic,
        minRating: minRating ?? this.minRating,
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );
}

// ─── Products Provider ────────────────────────────────────
final productFilterProvider = StateProvider<ProductFilter>(
  (ref) => const ProductFilter(),
);

final productsProvider = FutureProvider.family<Map<String, dynamic>, ProductFilter>(
  (ref, filter) async {
    final dio = ref.watch(dioClientProvider);
    final response = await dio.instance.get(
      '/products',
      queryParameters: filter.toQueryParams(),
    );
    return response.data;
  },
);

// ─── Single Product ───────────────────────────────────────
final productDetailProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, productId) async {
    final dio = ref.watch(dioClientProvider);
    final response = await dio.instance.get('/products/$productId');
    return response.data['data'] as Map<String, dynamic>;
  },
);

// ─── Featured Products ────────────────────────────────────
final featuredProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.instance.get('/products/featured');
  return response.data['data'] as List<dynamic>;
});

// ─── Flash Sale Products ──────────────────────────────────
final flashSaleProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.instance.get('/products/flash-sale');
  return response.data['data'] as List<dynamic>;
});

// ─── Popular Products ─────────────────────────────────────
final popularProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.instance.get('/products/popular');
  return response.data['data'] as List<dynamic>;
});

// ─── Categories Provider ──────────────────────────────────
final categoriesProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.instance.get('/categories');
  return response.data['data'] as List<dynamic>;
});

// ─── Search Provider ──────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchSuggestionsProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.length < 2) return [];
  final dio = ref.watch(dioClientProvider);
  final response = await dio.instance.get(
    '/products/suggestions',
    queryParameters: {'q': query},
  );
  return response.data['data'] as List<dynamic>;
});
