import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './base.dart';

class ApiService {
  // 发送 POST 请求
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // 请求头
      final headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // 请求体
      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      // 设置超时时间（例如 15 秒）
      final response = await http.Client().post(
        Uri.parse('$base_url/api/v1/login'),
        headers: headers,
        body: body,
      );

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析 JSON 数据
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        // 确保返回的数据中包含 status_code 字段
        data['status_code'] = response.statusCode;
        print(data);
        final sharedPreferences = await SharedPreferences.getInstance();
        // 保存 token 到本地
        await sharedPreferences.setString(
            'token', data['data']['access_token']);
        return data;
      } else if (response.statusCode == 409) {
        return {'status_code': response.statusCode};
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // 返回包含状态码的空数据
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during login: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> getBasicInfo(String access_token) async {
    try {
      // 请求的 URL
      final url = Uri.parse('$base_url/api/v1/get_basic_info');

      // 请求头
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };

      // 创建 HTTP 客户端并设置超时时间
      final client = http.Client();

      // 发送 GET 请求
      final response = await client
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30)); // 设置超时时间为 30 秒

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析 JSON 数据
        final data = json.decode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        print(
            'Request failed with status code: ${response.statusCode} in basicInfo');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during getBasicInfo: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> getAllCourses(String access_token) async {
    try {
      final url = Uri.parse('$base_url/api/v1/get_all_courses');
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // 请求成功，解析返回的 JSON 数据
        final data = json.decode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        // 请求失败，打印状态码和错误信息
        print('请求失败，状态码: ${response.statusCode}');
        print('错误信息: ${response.body}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during getAllCourses: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> getScores(
      String access_token, String sinfo) async {
    try {
      // 请求 URL
      final url = Uri.parse('$base_url/api/v1/query_scores?sinfo=$sinfo');

      // 请求头
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };

      // 发送 POST 请求
      final response = await http.post(
        url,
        headers: headers,
        body: '', // 请求体为空
      );

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 请求成功，解析响应数据
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        responseData['status_code'] = response.statusCode;
        return responseData;
      } else {
        // 请求失败，打印错误信息
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during getScores: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> queryAllScores(String access_token) async {
    try {
      final url = Uri.parse('$base_url/api/v1/query_all_socres');
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // 请求成功，解析返回的 JSON 数据
        final data = json.decode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        // 请求失败，打印状态码和错误信息
        print('请求失败，状态码: ${response.statusCode}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during queryAllScores: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> queryExamSchedule(
      String access_token, sinfo) async {
    try {
      final url =
          Uri.parse('$base_url/api/v1/query_exam_schedule?sinfo=$sinfo');
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };
      final body = json.encode({}); // 空的 JSON 数据

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 请求成功，解析返回的 JSON 数据
        final data = json.decode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        // 请求失败，打印状态码和错误信息
        print('请求失败，状态码: ${response.statusCode}');
        print('错误信息: ${response.body}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during queryExamSchedule: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> queryStudentInfo(String access_token) async {
    try {
      final url = Uri.parse('$base_url/api/v1/query_student_info');
      final headers = {
        'accept': 'application/json',
        'token': access_token,
      };
      final body = json.encode({}); // 空的 JSON 数据

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 请求成功，解析返回的 JSON 数据
        final data = json.decode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        // 请求失败，打印状态码和错误信息
        print('请求失败，状态码: ${response.statusCode}');
        print('错误信息: ${response.body}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during queryStudentInfo: $e');
      return {'status_code': 500};
    }
  }

  Future<Map<String, dynamic>> queryExperimentTable(String access_token) async {
    try {
      final url = Uri.parse('$base_url/api/v1/query_exmp_table');
      final headers = {
        'accept': 'application/json',
        'token': access_token,
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({}); // 空的 JSON 数据

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 使用 UTF-8 解码响应体
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        data['status_code'] = response.statusCode;
        return data;
      } else {
        print('请求失败，状态码: ${response.statusCode}');
        print('错误信息: ${utf8.decode(response.bodyBytes)}');
        return {'status_code': response.statusCode};
      }
    } catch (e) {
      print('Error during queryExperimentTable: $e');
      return {'status_code': 500};
    }
  }
}
