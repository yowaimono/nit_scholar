import 'package:flutter/material.dart';
import 'package:nit_scholar/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dialog_helper.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoginDialog(),
    );
  }

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          '登录',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _usernameController,
              label: '账号',
              icon: Icons.person,
              isPassword: false,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              label: '密码',
              icon: Icons.lock,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _rememberPassword,
                  onChanged: (value) async {
                    setState(() => _rememberPassword = value ?? false);
                    if (!_rememberPassword) {
                      await _clearLoginInfo();
                    }
                  },
                  activeColor: Colors.blue,
                ),
                const Text(
                  '记住密码',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () async {
                  await _handleLogin();
                },
          child: _isLoading
              ? const Text('登录中...')
              : const Text(
                  '确认',
                  style: TextStyle(color: Colors.blue),
                ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '取消',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    bool isPassword = false,
  }) {
    final labelColor =
        obscureText && !_isPasswordVisible ? Colors.grey : Colors.blue;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isPassword ? labelColor : Colors.black,
        ),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: TextStyle(color: isPassword ? labelColor : Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请填写完整的信息')),
        );
      }
      return;
    }

    if (mounted) {
      setState(() => _isLoading = true);
    }

    final apiService = ApiService();
    final result = await apiService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result != null) {
      final statusCode = result['status_code'] as int;
      switch (statusCode) {
        case 200:
          if (_rememberPassword) {
            print('save login info');
            print('保存 token 到本地: ${result['data']['access_token']}');
            await _saveLoginInfo(
                _usernameController.text, _passwordController.text);
          } else {
            print('delete login info');
            await _clearLoginInfo();
          }
          DialogHelper.showSuccessDialog(context);
          break;
        case 408:
          DialogHelper.showTimeoutDialog(context);
          break;
        case 409:
          DialogHelper.showAlreadyLoggedInDialog(context);
          break;
        case 500:
          DialogHelper.showServerErrorDialog(context);
          break;
        default:
          DialogHelper.showUnknownErrorDialog(context);
          break;
      }
    } else {
      if (mounted) {
        DialogHelper.showNetworkErrorDialog(context);
      }
    }
  }

  Future<void> _loadLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberPassword = prefs.getBool('rememberPassword') ?? false;
    if (rememberPassword) {
      final username = prefs.getString('username') ?? '';
      final password = prefs.getString('password') ?? '';
      setState(() {
        _usernameController.text = username;
        _passwordController.text = password;
        _rememberPassword = true;
      });
    }
  }

  Future<void> _clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.setBool('rememberPassword', false);
  }

  Future<void> _saveLoginInfo(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setBool('rememberPassword', true);
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   bool obscureText = false,
  //   Widget? suffixIcon,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       prefixIcon: Icon(icon, color: Colors.black),
  //       suffixIcon: suffixIcon,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //       filled: true,
  //       fillColor: Colors.grey.shade100,
  //     ),
  //     validator: (value) => value?.isEmpty ?? true ? '$label 不能为空' : null,
  //   );
  // }
}
