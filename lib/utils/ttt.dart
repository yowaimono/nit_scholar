import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const MaterialApp(home: InAppWebViewExample()));

class InAppWebViewExample extends StatefulWidget {
  const InAppWebViewExample({super.key});

  @override
  State<InAppWebViewExample> createState() => _InAppWebViewExampleState();
}

class _InAppWebViewExampleState extends State<InAppWebViewExample> {
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
      appBar: AppBar(title: const Text('InAppWebView Example')),
      body: _buildWebPage(context),
    );
  }

  Widget _buildWebPage(BuildContext context) {
    return Container(
        // 高度为一半的屏幕
        // 宽度为屏幕宽度
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
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
              if (!url.toString().contains("plat/pay?")) {
                setState(() {
                  _showLoadingOverlay = true;
                });
                await Future.delayed(const Duration(seconds: 3));
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
        ]));
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
