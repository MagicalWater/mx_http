part of 'request_content.dart';

mixin RequestHeaderMixin {
  Map<String, dynamic>? _headers;

  /// 取得只可讀的headers
  Map<String, dynamic>? get headers => _headers;

  void addHeader(String key, {required dynamic value}) {
    _headers ??= <String, dynamic>{};
    _headers!.addPair(key: key, value: value);
  }

  /// 添加複數個抬頭
  void addHeaders(Map<String, dynamic> headers) {
    headers.forEach((key, value) {
      addHeader(key, value: value);
    });
  }
}
