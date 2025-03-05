import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nit_scholar/pages/main_screen.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:nit_scholar/widgets/login/checkbox.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoginProgressDialog(onLoggedIn: () {
          // Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinColor.fromHex("#FFFFFF"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_usernameController, false),
              const SizedBox(height: 16.0),
              _buildTextField(_passwordController, true),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: _login,
                child: _buildLoginButton(),
              ),
              const SizedBox(height: 16.0),
              _buildAgreementRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: MinColor.fromHex("#F2F5F7"),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromRGBO(100, 100, 100, 0.8),
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    var _width = double.infinity;
    if (kIsWeb) {
      print("Web detected");
      _width = double.infinity * 0.4;
    }
    return Container(
      width: _width,
      height: 60.0,
      decoration: BoxDecoration(
        color: _rememberMe
            ? MinColor.fromHex("#0A81FA")
            : MinColor.fromHex("#84C0FA"),
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(77, 216, 255, 0.3),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '登录',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleCheckbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = !value),
        ),
        const SizedBox(width: 8.0),
        const Text(
          '我已阅读并同意',
          style:
              TextStyle(fontSize: 14.0, color: Color.fromRGBO(34, 34, 34, 1)),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            '用户协议',
            style:
                TextStyle(fontSize: 14.0, color: MinColor.fromHex("#0882F8")),
          ),
        ),
      ],
    );
  }
}

class LoginProgressDialog extends StatefulWidget {
  final void Function()? onLoggedIn;

  const LoginProgressDialog({super.key, this.onLoggedIn});

  @override
  State<LoginProgressDialog> createState() => _LoginProgressDialogState();
}

class _LoginProgressDialogState extends State<LoginProgressDialog>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  String _status = '正在登录...';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(); // 循环动画

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _startLoginProcess();
  }

  Future<void> _startLoginProcess() async {
    final tasks = [
      '登录中...',
      '获取基础信息...',
      '获取课程表...',
      '获取成绩信息...',
      '获取所有学期成绩...',
      '获取考试安排...',
      '获取个人信息...',
      '获取实验课表...',
      '登陆学工系统...',
      '获取请假信息...',
      '登录完成'
    ];

    final appState = Provider.of<AppState>(context, listen: false);

    final taskFunctions = [
      () => appState.login(),
      () => appState.fetchAndSaveBasicInfo(),
      () => appState.fetchAndSaveSchedule(),
      () => appState.fetchAndSaveCourseGrades(),
      () => appState.fetchAndSaveAllGrades(),
      () => appState.fetchAndSaveExamSchedule(),
      () => appState.fetchAndSavePersonalInfo(),
      () => appState.fetchAndSaveExpeSchedule(),
      () => appState.loginStudent(),
      () => appState.fetchAndSaveLeaveInfo(),
    ];

    for (int i = 0; i < taskFunctions.length; i++) {
      bool success = await _executeTask(taskFunctions[i], tasks[i]);
      if (!success) break; // 如果某个任务失败，直接终止流程
    }

    widget.onLoggedIn?.call();
  }

  Future<bool> _executeTask(Future<bool> Function() task, String status) async {
    int maxRetries = 3; // 最大重试次数
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      bool success = await task(); // 直接获取任务返回的 bool 值

      if (success) {
        setState(() {
          _step++;
          _status = status; // 任务成功后更新状态
        });
        return true; // 任务成功
      } else {
        if (attempt < maxRetries) {
          setState(() {
            _status = "$status 失败，重试中 ($attempt/$maxRetries)..."; // 失败时更新 UI
          });
          await Future.delayed(const Duration(seconds: 1)); // 等待 1 秒后重试
        } else {
          setState(() {
            _status = "$status 失败，已跳过"; // 达到最大重试次数后，提示失败
          });
        }
      }
    }
    return false; // 任务最终失败
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            // 进度条
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _step / 10),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey[300],
                  ),
                  child: LinearProgressIndicator(
                    value: value,
                    borderRadius: BorderRadius.circular(16.0),
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            // 状态文本和加载动画
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _status,
                  style: const TextStyle(fontSize: 12.0),
                ),
                const SizedBox(width: 8.0),
                // 旋转动画始终在持续
                RotationTransition(
                  turns: _animation,
                  child: const Icon(
                    Icons.autorenew,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
