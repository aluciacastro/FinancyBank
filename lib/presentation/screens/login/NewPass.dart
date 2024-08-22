import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cesarpay/domain/controller/ControllerPassRecovery.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/Logo.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';

class NewPasswordScreen extends StatelessWidget {
  static const String routname = 'NewPassword';
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final newPasswordController = TextEditingController();
    final String? oobCode = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Stack(
        children: [
          const WaveBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CesarPayLogo(
                    logoPath: 'assets/images/newpass.png',
                  ),
                  const SizedBox(height: 5),
                  const CesarPayTitle(
                    topPadding: 5,
                    title: 'Nueva Contraseña',
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: newPasswordController,
                    label: 'Nueva Contraseña',
                    icon: Icons.lock,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El campo Contraseña es obligatorio';
                      } else if (value.length != 6) {
                        return 'La contraseña debe tener exactamente 6 dígitos';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La contraseña solo debe contener números';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Actualizar Contraseña',
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        final newPassword = newPasswordController.text.trim();
                        Provider.of<PasswordRecoveryProvider>(context, listen: false)
                            .resetPassword(newPassword, context, oobCode);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
