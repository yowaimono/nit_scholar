import 'package:flutter/material.dart';
import 'package:nit_scholar/api/api_service.dart';
import 'package:nit_scholar/api/leave_service.dart';
import 'package:nit_scholar/models/basic_info.dart';
import 'package:nit_scholar/models/course_grade.dart';
import 'package:nit_scholar/models/course_response.dart';
import 'package:nit_scholar/models/exam_info.dart';
import 'package:nit_scholar/models/expe_table.dart';
import 'package:nit_scholar/models/leave_info.dart';
import 'package:nit_scholar/models/personal_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // 用于 JSON 编码和解码

class AppState with ChangeNotifier {
  String _token = '';

  // 删除未使用的 _allData
  // Map<String, dynamic> _allData = {};

  // 账号密码
  Map<String, dynamic> _userInfo = {};

  SemesterInfoModel _basicInfo = SemesterInfoModel();
  Schedule _schedule = Schedule(weeks: []);
  PersonalInfo _personalInfo = PersonalInfo();
  CourseGradesResponse _courseGrades = CourseGradesResponse(
      data: [], count: 0, tjsj: '', pjxfjdts: '', isXsckpscj: 0);
  CourseGradesResponse _allGrades = CourseGradesResponse(
      data: [], count: 0, tjsj: '', pjxfjdts: '', isXsckpscj: 0);
  ExamInfoResponse _examSchedule = ExamInfoResponse(exams: [], totalExams: 0);
  ExperimentSchedule _expeSchedule = ExperimentSchedule(weeks: []);
  LeaveResponse _leaveInfo = LeaveResponse();

  // getter（_allData 删除了，因为无实际用途）
  Map<String, String> get userInfo => {
        'username': _userInfo['username'] ?? '',
        'password': _userInfo['password'] ?? '',
      };
  Schedule get schedule => _schedule;
  LeaveResponse get leaveInfo => _leaveInfo;
  CourseGradesResponse get courseGrades => _courseGrades;
  PersonalInfo get personalInfo => _personalInfo;
  CourseGradesResponse get allGrades => _allGrades;
  SemesterInfoModel get basicInfo => _basicInfo;
  ExperimentSchedule get expeSchedule => _expeSchedule;
  ExamInfoResponse get examSchedule => _examSchedule;

  // 登录方法，增加 try-catch 以防异常
  Future<bool> login() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 从持久化中读取账号密码
      _userInfo['username'] = prefs.getString('username') ?? '';
      _userInfo['password'] = prefs.getString('password') ?? '';

      final apiService = ApiService();
      const maxRetries = 3;
      const retryDelay = Duration(seconds: 2);

      int retryCount = 0;
      while (retryCount < maxRetries) {
        try {
          final response = await apiService.login(
              _userInfo['username'], _userInfo['password']);

          if (response != null &&
              response['status_code'] == 200 &&
              response['data'] != null) {
            _token = response['data']['access_token'] ?? '';
            await prefs.setString('token', _token);
            print('登录成功，token: $_token');
            return true;
          } else if (response != null &&
              ([500, 501].contains(response['status_code']))) {
            retryCount++;
            if (retryCount < maxRetries) {
              await Future.delayed(retryDelay);
            }
          } else if (response != null && response['status_code'] == 409) {
            print('登录失败，状态码: ${response['status_code']}');
            _token = prefs.getString('token') ?? '';
            return true;
          } else {
            print('未知的登录响应: $response');
            return false;
          }
        } catch (e) {
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(retryDelay);
          } else {
            print('登录失败，错误: $e');
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      print('登录过程中出现异常: $e');
      return false;
    }
  }

  Future<void> fetchAndPersistData() async {
    try {
      bool isSuccess = await login();
      if (!isSuccess) {
        print('登录失败，无法获取数据');
        return;
      }
    } catch (e) {
      print('登录异常: $e');
      return;
    }

    try {
      bool isSuccess = await fetchAndSaveBasicInfo();
      print(isSuccess ? '获取基础信息成功，开始获取其他数据' : '获取基础信息失败，无法获取其他数据');
    } catch (e) {
      print('异常获取基础信息: $e');
    }

    try {
      bool isSuccess = await fetchAndSaveSchedule();
      print(isSuccess ? '获取课程表成功，开始获取其他数据' : '获取课程表失败，无法获取其他数据');
    } catch (e) {
      print('异常获取课程表: $e');
    }

    try {
      bool isSuccess = await fetchAndSaveCourseGrades();
      print(isSuccess ? '获取成绩信息成功，开始获取其他数据' : '获取成绩信息失败，无法获取其他数据');
    } catch (e) {
      print('异常获取成绩信息: $e');
    }

    try {
      bool isSuccess = await fetchAndSaveAllGrades();
      print(isSuccess ? '获取所有学期成绩成功，开始获取其他数据' : '获取所有学期成绩失败，无法获取其他数据');
    } catch (e) {
      print('异常获取所有学期成绩: $e');
    }

    try {
      bool isSuccess = await fetchAndSaveExamSchedule();
      print(isSuccess ? '获取考试安排成功，开始获取其他数据' : '获取考试安排失败，无法获取其他数据');
    } catch (e) {
      print('异常获取考试安排: $e');
    }

    try {
      bool isSuccess = await fetchAndSavePersonalInfo();
      print(isSuccess ? '获取个人信息成功，开始获取其他数据' : '获取个人信息失败，无法获取其他数据');
    } catch (e) {
      print('异常获取个人信息: $e');
    }

    try {
      bool isSuccess = await fetchAndSaveExpeSchedule();
      print(isSuccess ? '获取实验课表成功，开始获取其他数据' : '获取实验课表失败，无法获取其他数据');
    } catch (e) {
      print('异常获取实验课表: $e');
    }

    try {
      bool isSuccess = await loginStudent();
      print(isSuccess ? '登录学工系统成功，开始获取其他数据' : '登录学工系统失败，无法获取其他数据');
      if (isSuccess) {
        bool leaveSuccess = await fetchAndSaveLeaveInfo();
        print(leaveSuccess ? '获取请假信息成功，开始获取其他数据' : '获取请假信息失败，无法获取其他数据');
      }
    } catch (e) {
      print('异常登录学工系统或获取请假信息: $e');
    }

    notifyListeners();
  }

  // 获取基础信息并持久化
  Future<bool> fetchAndSaveBasicInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final response = await apiService.getBasicInfo(_token);
      if (response != null && response['status_code'] == 200) {
        print("获取基础信息成功");
        _basicInfo = SemesterInfoModel.fromJson(
            response['data'] as Map<String, dynamic>);
        await prefs.setString('basicInfo', jsonEncode(_basicInfo.toJson()));
        return true;
      } else {
        print('获取基础信息失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取基础信息: $e');
      return false;
    }
  }

  // 获取课程表并持久化
  Future<bool> fetchAndSaveSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.getAllCourses(token);
      if (response != null && response['status_code'] == 200) {
        print("获取课程表成功");
        _schedule = Schedule.fromJson(response['data']);
        await prefs.setString('schedule', jsonEncode(_schedule.toJson()));
        return true;
      } else {
        print('获取课程表失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取课程表: $e');
      return false;
    }
  }

  Future<bool> loginStudent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? '';
      final password = prefs.getString('password') ?? '';
      final apiService = LeaveService();
      final response = await apiService.loginToLeave(username, password);
      if (response != null && response['status_code'] == 200) {
        print("登录成功学工系统");
        await prefs.setString(
            'xgxt_token', response['data']['access_token'] as String);
        return true;
      } else if (response != null && response['status_code'] == 409) {
        return true;
      } else {
        print('登录学工系统失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常登录学工系统: $e');
      return false;
    }
  }

  // 获取成绩信息并持久化
  Future<bool> fetchAndSaveCourseGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.getScores(token, '2024-2025-1');
      if (response['status_code'] == 200) {
        print("获取成绩信息成功");
        _courseGrades = CourseGradesResponse.fromJson(response['data']);
        await prefs.setString(
            'courseGrades', jsonEncode(_courseGrades.toJson()));
        return true;
      } else {
        print('获取成绩信息失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取成绩信息: $e');
      return false;
    }
  }

  // 获取所有学期成绩并持久化
  Future<bool> fetchAndSaveAllGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.queryAllScores(token);
      if (response != null && response['status_code'] == 200) {
        print("获取所有学期成绩成功");
        _allGrades = CourseGradesResponse.fromJson(response['data']);
        await prefs.setString('allGrades', jsonEncode(_allGrades.toJson()));
        return true;
      } else {
        print('获取所有学期成绩失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取所有学期成绩: $e');
      return false;
    }
  }

  // 获取考试安排并持久化
  Future<bool> fetchAndSaveExamSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.queryExamSchedule(token, '2024-2025-1');
      if (response != null && response['status_code'] == 200) {
        print("获取考试安排成功");
        _examSchedule = ExamInfoResponse.fromJson(response['data']);
        await prefs.setString(
            'examSchedule', jsonEncode(_examSchedule.toJson()));
        return true;
      } else {
        print('获取考试安排失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取考试安排: $e');
      return false;
    }
  }

  Future<bool> fetchAndSaveLeaveInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('xgxt_token') ?? '';
      print('xgxt_token: $token');
      final apiService = LeaveService();
      final response = await apiService.getLeaveInfo(token);
      if (response != null && response['status_code'] == 200) {
        print("获取请假信息成功");
        _leaveInfo = LeaveResponse.fromJson(response['data']);
        await prefs.setString('leaveInfo', jsonEncode(_leaveInfo.toJson()));
        return true;
      } else {
        print('获取请假信息失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取请假信息: $e');
      return false;
    }
  }

  // 获取学生信息并持久化
  Future<bool> fetchAndSavePersonalInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.queryStudentInfo(token);
      if (response != null && response['status_code'] == 200) {
        print("获取学生信息成功");
        _personalInfo = PersonalInfo.fromJson(response['data']);
        await prefs.setString(
            'personalInfo', jsonEncode(_personalInfo.toJson()));
        return true;
      } else {
        print('获取学生信息失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取学生信息: $e');
      return false;
    }
  }

  // 获取实验课表并持久化
  Future<bool> fetchAndSaveExpeSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final apiService = ApiService();
      final response = await apiService.queryExperimentTable(token);
      if (response != null && response['status_code'] == 200) {
        print("获取实验课表成功");
        _expeSchedule = ExperimentSchedule.fromJson(response['data']);
        await prefs.setString(
            'expeSchedule', jsonEncode(_expeSchedule.toJson()));
        return true;
      } else {
        print('获取实验课表失败，状态码: ${response?['status_code']}');
        return false;
      }
    } catch (e) {
      print('异常获取实验课表: $e');
      return false;
    }
  }

  // 从持久化数据加载成对象更新到内存
  Future<void> loadDataFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('开始从持久化数据加载到内存');

      final basicInfoString = prefs.getString('basicInfo');
      if (basicInfoString != null) {
        _basicInfo = SemesterInfoModel.fromJson(jsonDecode(basicInfoString));
      }
      print('基础信息加载完成');

      final scheduleString = prefs.getString('schedule');
      if (scheduleString != null) {
        _schedule = Schedule.fromJson(jsonDecode(scheduleString));
      }
      print('课程表加载完成');

      final courseGradesString = prefs.getString('courseGrades');
      if (courseGradesString != null) {
        _courseGrades =
            CourseGradesResponse.fromJson(jsonDecode(courseGradesString));
      }
      print('成绩信息加载完成');

      final allGradesString = prefs.getString('allGrades');
      if (allGradesString != null) {
        _allGrades = CourseGradesResponse.fromJson(jsonDecode(allGradesString));
      }
      print('所有学期成绩加载完成');

      final examScheduleString = prefs.getString('examSchedule');
      if (examScheduleString != null) {
        _examSchedule =
            ExamInfoResponse.fromJson(jsonDecode(examScheduleString));
      }
      print('考试安排加载完成');

      final personalInfoString = prefs.getString('personalInfo');
      if (personalInfoString != null) {
        _personalInfo = PersonalInfo.fromJson(jsonDecode(personalInfoString));
      }
      print('学生信息加载完成');

      final expeScheduleString = prefs.getString('expeSchedule');
      if (expeScheduleString != null) {
        _expeSchedule =
            ExperimentSchedule.fromJson(jsonDecode(expeScheduleString));
      }
      print('实验课表加载完成');

      final leaveInfoString = prefs.getString('leaveInfo');
      if (leaveInfoString != null) {
        _leaveInfo = LeaveResponse.fromJson(jsonDecode(leaveInfoString));
      }
      print('请假信息加载完成');

      print('数据加载完成');
    } catch (e) {
      print('加载持久化数据时出现异常: $e');
    }

    notifyListeners();
  }

  // 刷新方法，负责从远程拉取并更新到内存和持久化
  Future<void> refreshData() async {
    await fetchAndPersistData();
    await loadDataFromStorage();
  }
}
