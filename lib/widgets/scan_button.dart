import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanButton extends StatelessWidget {
  ScanButton({Key? key}) : super(key: key);

  final MobileScannerController cameraController =
      MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () {
        // Afegim les 4 entrades automàtiques
        List<String> dummyScans = [
          'geo:41.3879,2.16992',
          'geo:40.4168,-3.7038',
          'http://example.com',
          'https://flutter.dev',
        ];

        for (var valor in dummyScans) {
          scanListProvider.nouScan(valor);
        }

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final barcode = capture.barcodes.first;

                        if (barcode.rawValue == null) return;

                        final String valor = barcode.rawValue!;
                        final ScanModel nouScan =
                            ScanModel(valor: valor);

                        scanListProvider.nouScan(valor);

                        Navigator.pop(context);

                        launchURL(context, nouScan);
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
