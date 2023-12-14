import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? qrViewController;
  String qrData = ''; // Для хранения данных QR-кода.

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                backgroundColor: Colors.orange,

        title: Center(child: Text('QR Scanner/Generator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'QR Data: $qrData',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  // Логика сохранения или отправки QR-кода.
                  // Например, сохранение в файл или отправка по электронной почте.
                },
                child: Text('Save/Send QR Data'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData.code!;
      });
    });
  }
}
