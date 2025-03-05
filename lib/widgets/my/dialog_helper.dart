import 'package:flutter/material.dart';
import 'package:nit_scholar/widgets/my/login_dialog.dart';

class DialogHelper {
  static void showTimeoutDialog(BuildContext context) {
    _showDialog(
      context,
      icon: Icons.timer_off,
      color: Colors.amber,
      title: '请求超时',
      content: '服务器响应时间过长，请检查网络或稍后重试',
      actions: [
        _DialogButton(text: '立即重试', onPressed: () => _reopenLogin(context)),
        _DialogButton(text: '稍后再说'),
      ],
    );
  }

  static void showAlreadyLoggedInDialog(BuildContext context) {
    _showDialog(context,
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
        title: '登录冲突',
        content: '该账号已在其他设备登录，请先注销原有登录',
        actions: [
          _DialogButton(
            text: '确定',
            onPressed: () => _reopenLogin(context),
          ),
        ]);
  }

  static void showServerErrorDialog(BuildContext context) {
    _showDialog(
      context,
      icon: Icons.dns_outlined,
      color: Colors.red,
      title: '服务不可用',
      content: '服务器暂时无法处理请求，请稍后再试',
      actions: [
        _DialogButton(text: '重试', onPressed: () => _reopenLogin(context)),
        _DialogButton(text: '取消'),
      ],
    );
  }

  static void showUnknownErrorDialog(BuildContext context) {
    _showDialog(context,
        icon: Icons.error_outline,
        color: Colors.purple,
        title: '未知错误',
        content: '发生未预期的错误，请联系技术支持',
        actions: [
          _DialogButton(text: '确定', onPressed: () => _reopenLogin(context)),
        ]);
  }

  static void showNetworkErrorDialog(BuildContext context) {
    _showDialog(
      context,
      icon: Icons.wifi_off_rounded,
      color: Colors.blueGrey,
      title: '网络异常',
      content: '无法连接服务器，请检查网络连接',
      actions: [
        _DialogButton(text: '重试', onPressed: () => _reopenLogin(context)),
        _DialogButton(text: '取消'),
      ],
    );
  }

  static void showSuccessDialog(BuildContext context) {
    if (!context.mounted) return; // 确保上下文仍然有效
    _showDialog(
      context,
      icon: Icons.check_circle,
      color: Colors.green,
      title: '登录成功',
      content: '您已成功登录',
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
          child: const Text('确定', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  static void _showDialog(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String content,
    List<Widget> actions = const [],
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(icon, color: color, size: 48),
        title: Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: actions,
      ),
    );
  }

  static void _reopenLogin(BuildContext context) {
    Navigator.of(context).pop();
    // LoginDialog.show(context);
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _DialogButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      child: Text(text),
    );
  }
}
