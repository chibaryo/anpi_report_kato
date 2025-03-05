import 'package:anpi_report_flutter/providers/qrtext/qrtext_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../router/app_router.dart';

@RoutePage()
class ScanQRScreen extends HookConsumerWidget {
  const ScanQRScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final scanCodeText = useState<String?>("");
    final scannerController = useMemoized(() => MobileScannerController());

    // Notifier
    final qrTextProvider = ref.watch(qrTextNotifierProvider);


    useEffect(() {
      return () {
        scannerController.dispose(); // Dispose the controller when the widget is disposed
      };
    }, [scannerController]);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: 
                  Builder(
                    builder: (context) {
                      return MobileScanner(
                        controller: scannerController,
                        fit: BoxFit.contain,
                        onDetect: (scandata) async {
                          // Stop the scanner and navigate to the ScanDataWidget
                          scannerController.stop();
                          if (scandata.barcodes.first.rawValue != "") {
                            ref.read(qrTextNotifierProvider.notifier).updateQrText(scandata.barcodes.first.rawValue!);
                            if (context.mounted) {
                              context.router.maybePop();
                            }
                          }
                        },
                      );
                    }
                  ),                  
    );
  }
}
