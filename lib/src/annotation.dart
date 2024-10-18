/// 宣告一個 abstract class 是個 api 請求的 interface
class RequestIF {
  const RequestIF();
}

/// 靜態的請求內容
class StaticRequest {
  final String? path;
  final String? scheme;
  final String? host;
  final int? port;
  final Object? body;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;

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
  /// class Headers: (in dio)
  ///   static const jsonContentType = 'application/json';
  ///   static const formUrlEncodedContentType = 'application/x-www-form-urlencoded';
  ///   static const textPlainContentType = 'text/plain';
  ///   static const multipartFormDataContentType = 'multipart/form-data';
  final String? contentType;

  const StaticRequest({
    this.path,
    this.body,
    this.scheme,
    this.host,
    this.port,
    this.method,
    this.contentType,
    this.headers,
    this.queryParameters,
  });
}

/// 宣告 method 裡面的參數為 path 裡面的變數
/// path的變數不可為可空
class Path {
  final String name;

  const Path(this.name);
}

/// 宣告 method 裡面的參數為 header
/// 若 ignoreNull 為 true, 則當參數為 null 時, 不會帶入 header
class Header {
  final String name;
  final bool ignoreNull;

  const Header(this.name, {this.ignoreNull = true});
}

/// 宣告 method 裡面的參數為 queryParam
/// 若 ignoreNull 為 true, 則當參數為 null 時, 不會帶入 queryParam
class Query {
  final String name;
  final bool ignoreNull;

  const Query(this.name, {this.ignoreNull = true});
}

/// 宣告 method 裡面的參數為 body
/// 若 ignoreNull 為 true, 則當參數為 null 時, 不會帶入 body
/// 若沒有指定 name, 則代表設置的是rawBody
class Body {
  final String? name;
  final bool ignoreNull;

  const Body(
    this.name, {
    this.ignoreNull = true,
  });
}
