import 'dart:convert';

part 'header_mixin.dart';

part 'query_mixin.dart';

part 'body_mixin.dart';

/// 請求內容
class RequestContent
    with RequestBodyMixin, RequestHeaderMixin, RequestQueryMixin {
  final String? scheme;
  final String? host;
  final String? path;
  final int? port;

  /// 不包含queryParameters的uri
  Uri get uri => Uri(
        scheme: scheme,
        host: host,
        path: path,
        port: port,
      );

  /// 請求method
  /// 可透過[RequestMethods]賦予
  /// class RequestMethods:
  ///   static const get = 'GET';
  ///   static const post = 'POST';
  ///   static const put = 'PUT';
  ///   static const delete = 'DELETE';
  ///   static const patch = 'PATCH';
  ///   static const head = 'HEAD';
  ///   static const options = 'OPTIONS';
  final String? method;

  /// 可透過[Headers]賦予
  /// class Headers:
  ///   static const jsonContentType = 'application/json';
  ///   static const formUrlEncodedContentType = 'application/x-www-form-urlencoded';
  ///   static const textPlainContentType = 'text/plain';
  ///   static const multipartFormDataContentType = 'multipart/form-data';
  final String? contentType;

  RequestContent({
    this.scheme,
    this.host,
    this.path,
    this.port,
    this.method,
    this.contentType,
  });

  /// copy with
  RequestContent copyWith({
    String? scheme,
    String? host,
    String? path,
    int? port,
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? method,
    String? contentType,
  }) {
    return RequestContent(
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      path: path ?? this.path,
      port: port ?? this.port,
      method: method ?? this.method,
      contentType: contentType ?? this.contentType,
    )
      .._headers = headers ?? _headers
      .._queryParameters = queryParameters ?? _queryParameters
      .._body = body ?? _body;
  }
}

/// 添加key到Map的快速操作
extension _RequestMap on Map<String, dynamic> {
  void addPair({
    required String key,
    required dynamic value,
  }) {
    if (containsKey(key)) {
      // 已包含key
      // 檢查原本的值
      // 如果原本的值是List, 則直接添加
      // 若為其他的則轉為list再添加
      var oriValue = this[key];
      this[key] = <dynamic>[
        if (oriValue is List) ...oriValue else oriValue,
        if (value is List) ...value else value,
      ];
    } else {
      // 未包key, 全新的
      this[key] = value;
    }
  }
}
