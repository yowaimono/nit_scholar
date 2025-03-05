class ApiResponse<T> {
  final String message;
  final T data;
  final dynamic error;

  ApiResponse({
    required this.message,
    required this.data,
    this.error,
  });

  // 从 JSON 数据中解析对象
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      message: json['message'],
      data: fromJson(json['data']),
      error: json['error'],
    );
  }
}