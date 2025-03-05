import 'package:flutter/material.dart';
import 'package:nit_scholar/pages/login_page.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogin = await AuthService.getUserCredentials();
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  MyApp({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final appState = AppState();
        // 启动时立即加载本地数据
        appState.loadDataFromStorage();
        return appState;
      },
      child: MaterialApp(
        title: 'NIT Scholar',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: isLogin ? MainScreen() : LoginPage(),
      ),
    );
  }
}
