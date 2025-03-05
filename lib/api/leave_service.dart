import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nit_scholar/api/base.dart';

class LeaveService {
  final http.Client _client = http.Client(); // 复用 HTTP 客户端

  // 发送 HTTP 请求的通用方法
  Future<Map<String, dynamic>> _sendRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request();

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        print('请求失败: ${response.statusCode}, 响应: ${response.body}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('请求异常: $e');
      return {'status_code': 500, 'error': e.toString()};
    }
  }

  // 登录请假系统
  Future<Map<String, dynamic>> loginToLeave(String username, String password) {
    final uri = Uri.parse('$base_url/api/v1/login_to_leave');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'username': username, 'password': password});

    return _sendRequest(() => _client.post(uri, headers: headers, body: body));
  }

  // 获取请假信息
  Future<Map<String, dynamic>> getLeaveInfo(String accessToken) {
    final uri = Uri.parse('$base_url/api/v1/leave_info');
    final headers = {
      'accept': 'application/json',
      'token': accessToken,
    };

    return _sendRequest(() => _client.get(uri, headers: headers));
  }

  // 获取请假详情
  Future<Map<String, dynamic>> getLeaveDetail(String accessToken, String eid) {
    final uri = Uri.parse('$base_url/api/v1/leave_detail/$eid');
    final headers = {
      'accept': 'application/json',
      'token': accessToken,
    };

    return _sendRequest(() => _client.get(uri, headers: headers));
  }
}
