import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

WebViewController useWebViewController() {
  return use(const _WebViewController());
}

class _WebViewController extends Hook<WebViewController> {
  const _WebViewController();

  @override
  _WebViewControllerState createState() => _WebViewControllerState();
}

class _WebViewControllerState
    extends HookState<WebViewController, _WebViewController> {
  final WebViewController _controller = WebViewController()
    ..loadRequest(Uri.parse("https://chibaryo.github.io/anpi_report_kato/terms/"))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ;

  @override
  WebViewController build(BuildContext context) {
    return _controller;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

@RoutePage()
class TermsWebViewScreen extends HookConsumerWidget {
  const TermsWebViewScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webViewController = useWebViewController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("利用規約"),
        backgroundColor: Colors.purple[300],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: WebViewWidget(
                controller: webViewController,
              ),
            ),
          ],
        )
      )
    );
  }
}
