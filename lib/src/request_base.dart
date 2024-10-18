import 'package:mx_http/src/request_content/request_content.dart';

/// api content構建
abstract class RequestBase {
  RequestContent get base => _base;
  RequestContent _base;

  RequestBase(RequestContent base) : _base = base;

  /// 變更base
  void changeBase(RequestContent base) {
    _base = base;
  }
}
