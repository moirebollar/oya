import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/core/theme/app_colors.dart';
import 'package:oya/core/utils/validators.dart';
import 'package:oya/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:oya/features/auth/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  String _selectedCountry = 'NL';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final language = _selectedCountry == 'NL'
        ? 'nl'
        : _selectedCountry == 'ES'
            ? 'es'
            : 'en';
    await ref.read(authNotifierProvider.notifier).signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          country: _selectedCountry,
          language: language,
          displayName: _nameCtrl.text.trim(),
        );
    if (!mounted) return;
    final error = ref.read(authNotifierProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.appName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l.signUpTitle,
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(l.signUpSubtitle,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 40),
                AuthTextField(
                  label: l.signUpName,
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) =>
                      Validators.name(v, requiredMsg: l.validationNameRequired),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: l.signUpEmail,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) => Validators.email(v,
                      requiredMsg: l.validationEmailRequired,
                      invalidMsg: l.validationEmailInvalid),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: l.signUpPassword,
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => Validators.password(v,
                      requiredMsg: l.validationPasswordRequired,
                      tooShortMsg: l.validationPasswordTooShort),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: l.signUpConfirmPassword,
                  controller: _confirmCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) => Validators.confirmPassword(
                      v, _passwordCtrl.text,
                      noMatchMsg: l.validationPasswordsNoMatch),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCountry,
                  decoration: InputDecoration(labelText: l.signUpCountry),
                  items: [
                    DropdownMenuItem(
                        value: 'NL', child: Text(l.signUpCountryNL)),
                    DropdownMenuItem(
                        value: 'ES', child: Text(l.signUpCountryES)),
                    DropdownMenuItem(
                        value: 'OTHER',
                        child: Text(l.signUpCountryOther)),
                  ],
                  onChanged: (v) => setState(() => _selectedCountry = v!),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l.signUpButton),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.signUpHaveAccount),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l.signUpSignIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
