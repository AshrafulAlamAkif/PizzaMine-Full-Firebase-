import '../../core/device/device_service.dart';
import '../../core/exceptions.dart';

import '../customer/customer_model.dart';
import '../customer/customer_repository.dart';

import 'auth_model.dart';
import 'auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final CustomerRepository _customerRepository;
  final DeviceService _deviceService;

  AuthService({
    required AuthRepository authRepository,
    required CustomerRepository customerRepository,
    required DeviceService deviceService,
  })  : _authRepository = authRepository,
        _customerRepository = customerRepository,
        _deviceService = deviceService;

  Future<void> _ensureCustomer(AppUser user) async {
    try {
      // Check whether customer document already exists.
      final existingCustomer =
          await _customerRepository.getCustomer(user.id);

      if (existingCustomer != null) {
        return;
      }

      // Get installation ID.
      final installationId =
          await _deviceService.getInstallationId();

      // Get device information.
      final deviceInfo =
          await _deviceService.getDeviceInfo();

      // Create customer profile.
      final customer = Customer(
        uid: user.id,
        fullName: user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : user.email.split('@').first,
        email: user.email,
        phoneNumber: null,
        role: 'customer',
        isActive: true,
        installationId: installationId,
        deviceInfo: deviceInfo,
      );

      await _customerRepository.createCustomer(customer);
    } catch (_) {
      throw const AppException(
        'Account authentication succeeded, but customer profile setup failed. Please try again.',
      );
    }
  }

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _authRepository.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );

    await _ensureCustomer(user);

    return user;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.signIn(
      email: email,
      password: password,
    );

    await _ensureCustomer(user);

    return user;
  }
}