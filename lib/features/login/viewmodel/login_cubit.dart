import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import '../model/login_response_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // ⚠️ عدّلي الـ baseUrl والـ path حسب الـ API
  static const String _baseUrl =
      'https://ecommerce-5rfssu72u-ahmed-allams-projects-14fb3aa3.vercel.app';
  static const String _loginPath = '/api/auth/login';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  String? token;

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final res = await _dio.post(
        _loginPath,
        // ⚠️ لو الـ API عايز "username" بدل "email" غيري الـ key هنا
        data: {'email': email, 'password': password},
      );

      final result =
      LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
      token = result.token;
      emit(LoginSuccess());
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map ? data['message'] : null) ??
          e.message ??
          'Something went wrong';
      emit(LoginFailure(msg.toString()));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}