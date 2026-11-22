
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_service.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});