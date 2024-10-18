part of 'request_content.dart';

mixin RequestQueryMixin {
  Map<String, dynamic>? _queryParameters;

  /// 取得只可讀的queryParameters
  Map<String, dynamic>? get queryParameters => _queryParameters;

  void addQuery(String key, {required dynamic value}) {
    _queryParameters ??= <String, dynamic>{};
    _queryParameters!.addPair(key: key, value: value);
  }

  /// 添加複數個抬頭
  void addQuerys(Map<String, dynamic> querys) {
    querys.forEach((key, value) {
      addQuery(key, value: value);
    });
  }
}
