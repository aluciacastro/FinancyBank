import 'package:cesarpay/domain/controller/ControllerProfile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesarpay/providers/RegisterProvider.dart';
import '../domain/controller/ControllerPassRecovery.dart';

final registerProvider = ChangeNotifierProvider<RegisterProvider>((ref) => RegisterProvider());
final passwordRecoveryProvider = ChangeNotifierProvider<PasswordRecoveryProvider>((ref) => PasswordRecoveryProvider());
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) => UserNotifier());
