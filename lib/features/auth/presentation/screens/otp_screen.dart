import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';

// ============================================================
// BARAKA MARKET — OTP Verification Screen
// Premium design with countdown timer and resend
// ============================================================

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  bool _canResend = false;
  int _countdown = 120;
  Timer? _timer;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 120;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  String get _countdownText {
    final mins = _countdown ~/ 60;
    final secs = _countdown % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length < 6) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (!mounted) return;
    // TODO: verify OTP via provider
    // On success:
    setState(() => _isLoading = false);
    context.go(AppRoutes.home);
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    // TODO: resend OTP via provider
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 58,
      height: 64,
      textStyle: TextStyle(
        fontSize: 22,
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w700,
        color: theme.brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? AppColors.darkOutline
              : AppColors.outline,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(14),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.error, width: 1.5),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Tasdiqlash'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('📱', style: TextStyle(fontSize: 40)),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              Text(
                'Kodni kiriting',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 8),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: '6 xonali kod '),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(text: '\nraqamiga yuborildi'),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 40),

              // OTP Input
              Pinput(
                controller: _otpController,
                focusNode: _focusNode,
                length: 6,
                autofocus: true,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: _verifyOtp,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(
                    begin: 0.2,
                    duration: 500.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  ),

              // Error
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _errorMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).animate().shakeX(duration: 500.ms),
              ],

              const SizedBox(height: 32),

              // Countdown / Resend
              _canResend
                  ? TextButton(
                      onPressed: _resendOtp,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh_rounded, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'Kodni qayta yuborish',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms)
                  : Text(
                      'Qayta yuborish: $_countdownText',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

              const Spacer(),

              // Verify Button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => _verifyOtp(_otpController.text),
                        child: const Text('Tasdiqlash'),
                      ),
              ).animate().slideY(
                    begin: 0.3,
                    duration: 500.ms,
                    delay: 500.ms,
                  ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
