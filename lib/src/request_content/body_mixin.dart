part of 'request_content.dart';

mixin RequestBodyMixin {
  Object? _body;

  /// 不做任何轉換, 直接取得body
  Object? get body => _body;

  /// 將body以row字串的方式取得
  /// 若body是key value, 則透過json.encode轉為String
  String? get bodyInRow {
    // 若body是String, 則直接回傳
    if (_body is String) {
      return _body as String?;
    } else if (_body is Map<String, dynamic>) {
      // 若body是Map<String, dynamic>, 則需要轉為json再轉為String
      // 這邊不進行非json可序列化的移除, 若有類似[dio.MultipartFile]等, 則會報錯
      // 應由外部自行獲取body排除
      final jsonResult = json.encode(_body);
      return jsonResult;
    }
    return null;
  }

  /// 將body以key-value的方式取得
  /// 若body是String, 則透過json.decode轉為Map<String, dynamic>
  Map<String, dynamic>? get bodyInKeyValue {
    // 若body是Map<String, dynamic>, 則直接回傳
    if (_body is Map<String, dynamic>) {
      return _body as Map<String, dynamic>;
    } else if (_body is String) {
      // 若body是String, 則嘗試需要轉為Map<String, dynamic>
      // 若body不是json格式, 則會報錯
      // 應由外部自行獲取body排除
      final jsonResult = json.decode(_body as String);
      return jsonResult;
    }
    return null;
  }

  /// 以row方式設置body
  void setBodyInRow(String? body) {
    _body = body;
  }

  /// 以key-value方式添加單個body
  void addBodyInKeyValue(String key, {required dynamic value}) {
    // 如果body是string, 則轉換為Map<String, dynamic>
    if (_body != null && _body is String) {
      _body = <String, dynamic>{};
    } else {
      _body ??= <String, dynamic>{};
    }
    (_body as Map<String, dynamic>).addPair(key: key, value: value);
  }

  /// 以key-value方式添加複數個body
  void addBodyInKeyValues(Map<String, dynamic> bodyMap) {
    bodyMap.forEach((key, value) {
      addBodyInKeyValue(key, value: value);
    });
  }
}
