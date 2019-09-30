import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class WelcomePage extends BasePage {
  static const _aspectRatioImage = 1.26;
  static const _baseWidth = 411.43;
  final _image = Image.asset('assets/images/welcomeImg.png');
  final _cakeLogo = Image.asset('assets/images/cake_logo.png');

  @override
  Widget body(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1;

    return Column(children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
              aspectRatio: _aspectRatioImage,
              child: FittedBox(child: _image, fit: BoxFit.fill)),
          Positioned(bottom: 0.0, child: _cakeLogo)
        ],
      ),
      Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(children: <Widget>[
          Text(
            'WELCOME\nTO CAKE WALLET',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Awesome wallet\nfor Monero',
            style: TextStyle(
              fontSize: 22.0,
              color: Palette.lightBlue,
            ),
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Please make selection below to\ncreate or recover your wallet.',
            style: TextStyle(
              fontSize: 16.0,
              color: Palette.lightBlue,
            ),
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          )
        ],
      )),
      Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(children: <Widget>[
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.newWalletFromWelcome);
              },
              text: 'Create New',
            ),
            SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.restoreOptions);
              },
              color: Palette.brightBlue,
              borderColor: Palette.cloudySky,
              text: 'Restore wallet',
            )
          ]))
    ]);
  }
}
