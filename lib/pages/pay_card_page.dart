import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PayCardPage extends StatefulWidget {
  const PayCardPage({Key? key}) : super(key: key);

  @override
  State<PayCardPage> createState() => _PayCardPageState();
}

class _PayCardPageState extends State<PayCardPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  String _url = 'https://yktwx.nit.edu.cn/plat/pay?loginFrom=h5';
  final _home = 'https://yktwx.nit.edu.cn/plat/shouyeUser';
  double progress = 0;
  double loadingContainerHeight = 50;
  final sessionKey = 'sessionKey';
  CookieManager cookieManager = CookieManager.instance();
  bool _showLoadingOverlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: const Text("校园卡"))), // Changed title

      body: _buildWebPage(context),
    );
  }

  Widget _buildWebPage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(_url)),
            initialOptions: InAppWebViewGroupOptions(
              ios: IOSInAppWebViewOptions(sharedCookiesEnabled: true),
              crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
            ),
            onWebViewCreated: (controller) async {
              webViewController = controller;
              await Future.delayed(const Duration(seconds: 3));
              await _setSessionStorage(controller);
            },
            onLoadStart: (controller, url) async {
              final sessionData = await _getSessionContent(controller);
              print("started to load: $url");

              final sessionDataInDisk = await _getSessionForDisk();
              print("Session content from disk: $sessionDataInDisk");

              if (!url.toString().contains("plat/pay?") &&
                  sessionDataInDisk.contains("userInfo")) {
                // 没到目标页面，重新加载
                setState(() {
                  _showLoadingOverlay = true;
                });
                await Future.delayed(const Duration(seconds: 2));
                setState(() {
                  _showLoadingOverlay = false;
                });
                controller.loadUrl(urlRequest: URLRequest(url: WebUri(_url)));
              }
              print("Current session content---: ${sessionData}");
            },
            onLoadStop: (controller, url) async {
              print("finished to load: $url");
              if (url.toString().contains("plat/pay")) {
                print("开始设置 sessionStorage");
                await _saveSession(controller);
                await _logSessionContent(controller);
              }
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
                if (progress == 100) {
                  print("progress completed");
                  loadingContainerHeight = 0;
                }
              });
            },
          ),
          if (loadingContainerHeight > 0)
            LinearProgressIndicator(value: progress),
          if (_showLoadingOverlay)
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<String> _getSessionForDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionContent = prefs.getString(sessionKey);

      // 使用空值合并运算符，提供更清晰的默认值
      return sessionContent ?? 'Session not found in disk.';

      // 或者，如果找不到 session 应该抛出异常
      // if (sessionContent == null) {
      //   throw Exception('Session not found in disk.');
      // }
      // return sessionContent;
    } catch (e) {
      // 处理 SharedPreferences 异常
      print('Error getting session from disk: $e');
      return 'Error retrieving session from disk.'; // 或者抛出异常
    }
  }

  Future<void> _logSessionContent(InAppWebViewController controller) async {
    final sessionContent = await _getSessionContent(controller);
    print("Current session content: $sessionContent");
  }

  Future<String> _getSessionContent(InAppWebViewController controller) async {
    final jsCode = """
      (function() {
        var data = {};
        for (var i = 0; i < sessionStorage.length; i++) {
          var key = sessionStorage.key(i);
          data[key] = sessionStorage.getItem(key);
        }
        return JSON.stringify(data);
      })();
    """;
    final sessionStorageData =
        await controller.evaluateJavascript(source: jsCode) as String;
    return sessionStorageData;
  }

  Future<void> _saveSession(InAppWebViewController controller) async {
    final sessionContent = await _getSessionContent(controller);
    print("try save session content: $sessionContent");
    if (sessionContent.contains("userInfo")) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionKey, sessionContent);
      print("saved Session content: $sessionContent");
    } else {
      print("Session content is empty or does not contain userInfo.");
    }
  }

  Future<void> _setSessionStorage(InAppWebViewController controller) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionContent = prefs.getString(sessionKey);

    if (sessionContent != null && sessionContent.contains("userInfo")) {
      try {
        await controller.webStorage.sessionStorage.clear();
        final sessionData = jsonDecode(sessionContent);
        sessionData.forEach((key, value) {
          controller.webStorage.sessionStorage
              .setItem(key: key, value: value.toString());
          print('Set sessionStorage key: $key, value: $value');
        });
        print(
            'Session storage set successfully using webStorage.sessionStorage.setItem');
        print(
            'Current sessionStorage: ${await _getSessionContent(controller)}');
      } catch (e) {
        print('Error setting sessionStorage: $e');
      }
    } else {
      print("Session content is empty or does not contain userInfo.");
    }
  }
}
