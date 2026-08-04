import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vendion/models/client_user.dart';
import 'package:vendion/services/credential_cache_service.dart';

void main() {
  setUp(() {
    FlutterSecureStoragePlatform.instance =
        TestFlutterSecureStoragePlatform({});
  });

  test('keeps cached credentials while they are inside the ttl', () async {
    final service = CredentialCacheService(
      storage: const FlutterSecureStorage(),
      ttl: const Duration(days: 3),
    );

    await service.save(ClientUser(email: 'user@test.com', password: 'secret'));

    final cached = await service.readValid();

    expect(cached?.email, 'user@test.com');
    expect(cached?.password, 'secret');
  });

  test('expires cached credentials when the ttl has passed', () async {
    final service = CredentialCacheService(
      storage: const FlutterSecureStorage(),
      ttl: Duration.zero,
    );

    await service.save(ClientUser(email: 'user@test.com', password: 'secret'));

    final cached = await service.readValid();

    expect(cached, isNull);
  });
}
