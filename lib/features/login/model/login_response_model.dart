class LoginResponseModel {
  final String token;
  final String? message;

  LoginResponseModel({required this.token, this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponseModel(
      token: (json['token'] ??
          json['accessToken'] ??
          (data is Map ? data['token'] : null) ??
          '')
          .toString(),
      message: json['message']?.toString(),
    );
  }
}