import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';

// ============================================================
// BARAKA MARKET — Login Screen (Phone + OTP)
// Premium UI with animations
// ============================================================

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedCode = '+998';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+998', 'flag': '🇺🇿', 'name': "O'zbekiston"},
    {'code': '+7', 'flag': '🇷🇺', 'name': 'Rossiya'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'AQSh'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (mounted) {
      setState(() => _isLoading = false);
      final phone = '$_selectedCode${_phoneController.text}';
      context.push(AppRoutes.otp, extra: phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D5C32), Color(0xFF1A8C4E)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🛒', style: TextStyle(fontSize: 40)),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 16),
                    const Text(
                      'Baraka Market',
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                    const SizedBox(height: 6),
                    const Text(
                      'Kirish yoki ro\'yxatdan o\'tish',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'NunitoSans',
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 32),

                // Title
                Text(
                  'Telefon raqamingizni kiriting',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().slideX(
                      begin: -0.2,
                      duration: 500.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 8),
                Text(
                  'Sms orqali tasdiqlash kodi yuboriladi',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Phone Input
                Form(
                  key: _formKey,
                  child: _PhoneInputField(
                    controller: _phoneController,
                    selectedCode: _selectedCode,
                    countryCodes: _countryCodes,
                    onCodeChanged: (code) =>
                        setState(() => _selectedCode = code),
                    validator: (value) {
                      if (value == null || value.length < 9) {
                        return 'Telefon raqamni to\'liq kiriting';
                      }
                      return null;
                    },
                  ),
                ).animate().slideY(
                      begin: 0.2,
                      duration: 500.ms,
                      delay: 400.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 32),

                // Submit Button
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
                          onPressed: _sendOtp,
                          child: const Text('Kodni olish'),
                        ),
                ).animate().slideY(
                      begin: 0.3,
                      duration: 500.ms,
                      delay: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 24),

                // Terms
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Davom etish orqali siz ',
                        style: theme.textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Foydalanish shartlari',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' va ',
                        style: theme.textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Maxfiylik siyosatiga',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' rozilik bildirgan bo\'lasiz.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                const SizedBox(height: 40),

                // Social Login (optional)
                _buildSocialDivider(theme),
                const SizedBox(height: 20),
                _buildSocialButtons(theme),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'yoki',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outline)),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  Widget _buildSocialButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Text('G', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFFDB4437))),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 52),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Text('f', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1877F2))),
            label: const Text('Facebook'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 52),
            ),
          ),
        ),
      ],
    ).animate().slideY(
          begin: 0.2,
          duration: 500.ms,
          delay: 800.ms,
          curve: Curves.easeOut,
        );
  }
}

// ─── Phone Input Field ─────────────────────────────────────
class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String> onCodeChanged;
  final FormFieldValidator<String>? validator;

  const _PhoneInputField({
    required this.controller,
    required this.selectedCode,
    required this.countryCodes,
    required this.onCodeChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      validator: validator,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
      decoration: InputDecoration(
        hintText: '90 123 45 67',
        hintStyle: TextStyle(
          letterSpacing: 1.5,
          color: AppColors.textHint,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: GestureDetector(
          onTap: () => _showCountryPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isDark ? AppColors.darkOutline : AppColors.outline,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  countryCodes
                      .firstWhere((e) => e['code'] == selectedCode)['flag']!,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 6),
                Text(
                  selectedCode,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: countryCodes.length,
          itemBuilder: (context, index) {
            final item = countryCodes[index];
            return ListTile(
              leading: Text(item['flag']!, style: const TextStyle(fontSize: 24)),
              title: Text(item['name']!),
              trailing: Text(item['code']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                onCodeChanged(item['code']!);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
