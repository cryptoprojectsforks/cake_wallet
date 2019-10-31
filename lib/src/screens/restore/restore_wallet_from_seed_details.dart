import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_store.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/blockchain_height_widget.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/stores/validation/validation_store.dart';

class RestoreWalletFromSeedDetailsPage extends BasePage {
  String get title => 'Wallet restore description';

  @override
  Widget body(BuildContext context) => RestoreFromSeedDetailsForm();
}

class RestoreFromSeedDetailsForm extends StatefulWidget {
  @override
  createState() => _RestoreFromSeedDetailsFormState();
}

class _RestoreFromSeedDetailsFormState
    extends State<RestoreFromSeedDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _blockchainHeightKey = GlobalKey<BlockchainHeightState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletRestorationStore = Provider.of<WalletRestorationStore>(context);
    final validation = Provider.of<ValidationStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    reaction((_) => walletRestorationStore.state, (state) {
      if (state is WalletRestoredSuccessfully) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (state is WalletRestorationFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.error),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        });
      }
    });

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 13, right: 13),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                controller: _nameController,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGrey
                                            : Palette.lightBlue),
                                    hintText: 'Wallet name',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isDarkTheme
                                                ? PaletteDark
                                                    .darkThemeGreyWithOpacity
                                                : Palette.lightGrey,
                                            width: 1.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isDarkTheme
                                                ? PaletteDark
                                                    .darkThemeGreyWithOpacity
                                                : Palette.lightGrey,
                                            width: 1.0))),
                                validator: (value) {
                                  validation.validateWalletName(value);
                                  if (!validation.isValidate) return 'Wallet name can only contain letters, '
                                      'numbers\nand must be between 1 and 15 characters long';
                                  return null;
                                },
                              ),
                            ))
                          ],
                        ),
                        BlockchainHeightWidget(key: _blockchainHeightKey),
                      ])),
              Flexible(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Observer(builder: (_) {
                        return LoadingPrimaryButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              walletRestorationStore.restoreFromSeed(
                                  name: _nameController.text,
                                  restoreHeight:
                                      _blockchainHeightKey.currentState.height);
                            }
                          },
                          isLoading:
                              walletRestorationStore.state is WalletIsRestoring,
                          text: 'Recover',
                          color: _isDarkTheme
                              ? PaletteDark.darkThemePurpleButton
                              : Palette.purple,
                          borderColor: _isDarkTheme
                              ? PaletteDark.darkThemePurpleButtonBorder
                              : Palette.deepPink,
                        );
                      })))
            ],
          ),
        ),
      ),
    );
  }
}
