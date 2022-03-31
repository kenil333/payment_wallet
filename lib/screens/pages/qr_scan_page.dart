import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tensopay_wallet_prototype/models/tenso_payment_data.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';

import '../../cubit/app_cubit_states.dart';
import '../../cubit/app_cubits.dart';
import '../../models/tenso_bank_account.dart';

class QrScan extends StatefulWidget {
  const QrScan({Key? key}) : super(key: key);
  static String tag = '/QrScanScreen';

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    controller?.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      // onQRViewCreated: qrview,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.black,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
        overlayColor: Colors.grey,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera().then((value) {
        String? result = scanData.code;
        debugPrint('Result from scanner:' + result!);
        TensoPayment payment = TensoPayment.fromJson(jsonDecode(result));
        TensoAccount? mainAccount = findMainAccount();
        BlocProvider.of<AppCubit>(context)
            .goToConfirmPayment(mainAccount!, payment);
      });

      //TensoPayment payment = TensoPayment.fromJson(result);
      setState(() {
        this.controller = controller;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        _buildQrView(context),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: size.width * 0.05),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ).onTap(() {
                BlocProvider.of<AppCubit>(context).goToMainPage(0);
              }),
            ),
            30.height,
            Text('Hold  your Card inside the frame',
                style: boldTextStyle(color: Colors.white, size: 18)),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(30), backgroundColor: Colors.white),
            child: const Icon(Icons.close, color: Colors.black, size: 30),
          ).onTap(() {
            BlocProvider.of<AppCubit>(context).goToMainPage(0);
          }),
        ).paddingBottom(60),
      ],
    ));
  }
}
