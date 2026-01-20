import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    return await dataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    return await dataSource.register(email, password);
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await dataSource.getCurrentUser();
  }
}
