class LoginData {
  final String accessToken;
  final String tokenType;

  LoginData({
    required this.accessToken,
    required this.tokenType,
  });

  // 从 JSON 数据中解析对象
  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}