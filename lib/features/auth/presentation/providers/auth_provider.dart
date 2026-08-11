import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/user_model.dart';

// ============================================================
// BARAKA MARKET — Auth Provider (Riverpod)
// ============================================================

// ─── Auth State ───────────────────────────────────────────
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
    bool? isLoading,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

// ─── Auth Notifier ────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final DioClient _dio;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._dio, this._storage) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      await _fetchProfile();
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  // Send OTP
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _dio.instance.post('/auth/send-otp', data: {'phone': phone});
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      rethrow;
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String phone, String code, {String? deviceId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.instance.post('/auth/verify-otp', data: {
        'phone': phone,
        'code': code,
        if (deviceId != null) 'deviceId': deviceId,
      });

      final data = response.data['data'];
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: data['accessToken'],
      );
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: data['refreshToken'],
      );

      await _fetchProfile();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
        status: AuthStatus.error,
      );
      rethrow;
    }
  }

  // Fetch user profile
  Future<void> _fetchProfile() async {
    try {
      final response = await _dio.instance.get('/users/me');
      final user = UserModel.fromJson(response.data['data']);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      await _clearTokens();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.instance.patch('/users/me', data: data);
      final user = UserModel.fromJson(response.data['data']);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _parseError(e));
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      await _dio.instance.post('/auth/logout', data: {'refreshToken': refreshToken});
    } catch (_) {}
    await _clearTokens();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return 'Xatolik yuz berdi';
  }
}

// ─── Providers ───────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dio = ref.watch(dioClientProvider);
  const storage = FlutterSecureStorage();
  return AuthNotifier(dio, storage);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});
