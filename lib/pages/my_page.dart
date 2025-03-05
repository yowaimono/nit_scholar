import 'package:flutter/material.dart';
import 'package:nit_scholar/pages/exam_plan_page.dart';
import 'package:nit_scholar/pages/login_page.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:nit_scholar/widgets/my/about_dialog.dart';
import 'package:nit_scholar/widgets/my/custom_list_tile.dart';
import 'package:nit_scholar/widgets/my/login_dialog.dart';
import 'package:nit_scholar/widgets/my/student_info_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black54, // 边框颜色
            width: 0.3, // 边框宽度
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text('我的'),
        backgroundColor: MinColor.fromHex("#F9F9F9"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              print('刷新');
              if (context.mounted) {
                final appState = Provider.of<AppState>(context, listen: false);
                await appState.fetchAndPersistData();
              }
              print('刷新完成');
            },
          )
        ],
      ),
      backgroundColor: MinColor.fromHex("#F5F5F3"),
      body: ListView(
        // padding: const EdgeInsets.all(16),
        children: [
          const StudentInfoCard(),
          const SizedBox(height: 30),
          CustomListTile(
            icon: Icons.logout,
            title: '退出登录',
            onTap: () => showLogoutDialog(context),
          ),
          CustomListTile(
            icon: Icons.edit,
            title: "我的考试",
            onTap: () => {
              print('跳转到考试页面'),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExamPlanPage()))
            },
          ),
          const SizedBox(height: 20),
          CustomListTile(
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () => print('跳转到帮助与反馈页面'),
          ),
          const SizedBox(height: 20),
          CustomListTile(
            icon: Icons.info_outline,
            title: '关于',
            onTap: () => CustomAboutDialog.show(context),
          ),
        ],
      ),
    );
  }

  // void _logout(BuildContext context) async {
  //   showDialog(context: context, builder:  )
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => LoginPage()));
  // }

  Future<void> _buildLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final screenWidth = constraints.maxWidth; // 获取屏幕宽度
              final dialogWidth =
                  screenWidth > 600 ? 600 : screenWidth * 0.8; // 动态调整对话框宽度
              final buttonWidth = dialogWidth / 3; // 动态调整按钮宽度
              final fontSize = screenWidth > 320 ? 18.0 : 16.0; // 动态调整字体大小

              return Container(
                width: dialogWidth.toDouble(),
                height: 180,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '提示',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '确定要退出登录吗？',
                      style: TextStyle(fontSize: fontSize),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    Wrap(
                      // 使用 Wrap 组件
                      alignment: WrapAlignment.center, // 居中排列
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: MinColor.fromHex("#EBF1FF"),
                            minimumSize: Size(buttonWidth, 50), // 动态调整按钮尺寸
                          ),
                          child: Text(
                            '取消',
                            style:
                                TextStyle(color: MinColor.fromHex("#6990EA")),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton(
                          onPressed: () async {
                            // 执行退出登录逻辑
                            print('执行退出登录操作');
                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();

                            // 使用动画跳转到登录页面
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: MinColor.fromHex("#5589FF"),
                            minimumSize: Size(buttonWidth, 50), // 动态调整按钮尺寸
                          ),
                          child: const Text(
                            '退出',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

// 使用示例
  void showLogoutDialog(BuildContext context) async {
    await _buildLogoutDialog(context);
    // 可以在这里处理对话框关闭后的逻辑
  }
}
