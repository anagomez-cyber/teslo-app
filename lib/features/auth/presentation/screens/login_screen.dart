import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Icon Banner
                  const Icon(
                    Icons.production_quantity_limits_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                  const SizedBox(height: 80),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: const _LoginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 50),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(loginFormProvider.notifier).onFormSubmit(),
            errorMessage: loginForm.isFormPosted
                ? loginForm.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.black,
              onPressed: loginForm.isPosting
                  ? null
                  : ref.read(loginFormProvider.notifier).onFormSubmit,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crea una aquí'))
            ],
          ),
        ],
      ),
    );
  }
}