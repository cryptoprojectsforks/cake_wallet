import 'package:mobx/mobx.dart';

part 'validation_store.g.dart';

class ValidationStore = ValidationStoreBase with _$ValidationStore;

abstract class ValidationStoreBase with Store {

  @observable
  bool isValidate;

  bool _validate(String value, String p) {
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value))
      return true;
    else
      return false;
  }

  @action
  void validateWalletName(String value) {
    String p = '^[a-zA-Z0-9_]{1,10}\$';
    isValidate = _validate(value, p);
  }

  @action
  void validateKeys(String value) {
    String p = '^[a-fA-F0-9]{64}\$';
    isValidate = _validate(value, p);
  }

  @action
  void validateAddress(String value) {
    String p = 'XMR|BTC|ETH|LTC|BCH|DASH';
    isValidate = _validate(value, p);
  }

  @action
  void validatePaymentID(String value) {
    String p = '^[a-fA-F0-9]{16,64}\$';
    isValidate = _validate(value, p);
  }

  @action
  void validateUSD(String value, double totalXMR, double rateXMRUSD, double fee) {
    const double minValue = 0.01;
    final double maxValue = totalXMR*rateXMRUSD - fee;
    String p = '^[0-9]*.[0-9]+';
    if (_validate(value, p)) {
      try {
        double dValue = double.parse(value);
        isValidate = (dValue >= minValue && dValue <= maxValue);
      } catch (e) {
        isValidate = false;
      }
    } else isValidate = false;
  }

  @action
  void validateXMR(String value, double maxAvailable, double fee) {
    const double maxValue = 18446744.073709551616;
    String p = '^[0-9]*.[0-9]{12}';
    if (_validate(value, p)) {
      try {
        double dValue = double.parse(value) + fee;
        isValidate = (dValue <= maxAvailable && dValue <= maxValue);
      } catch (e) {
        isValidate = false;
      }
    } else isValidate = false;
  }

  @action
  void validateSubaddressName(String value) {
    String p = '''^[^`,'"]{1,20}\$''';
    isValidate = _validate(value, p);
  }

  @action
  void validateNodePort(String value) {
    String p = '^[0-9]{1,5}';
    isValidate = _validate(value, p);
  }

  @action
  void validateNodeAddress(String value) {
    String p = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$';
    isValidate = _validate(value, p);
  }

  @action
  void validateContactName(String value) {
    String p = '''^[^`,'"]{1,32}\$''';
    isValidate = _validate(value, p);
  }

}