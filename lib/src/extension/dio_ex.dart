part of 'extension.dart';

extension DioEx on Dio {
  /// 使用 RequestContent 進行 request 呼叫
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式, 若有帶值, 且為key-value形式, 將會進行合併, 重複的部分將會以body為主
  /// [queryParameters] Query參數, 若此參數為null, 將會使用content的queryParameters, 若有帶值, 將會合併, 重複地將以queryParameters為主
  /// [cancelToken] 取消請求的token
  /// [options] content的options將會與此合併, 重複的則以options為主
  /// [onSendProgress] 發送進度
  /// [onReceiveProgress] 接收進度
  /// [formDataBuilder] FormData構建方法, 預設為[_defaultFormDataBuilder], 透過此方法可以自定義FormData的構建方式
  Future<Response<T>> mxRequest<T>(
    RequestContent content, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    FormDataBuilder formDataBuilder = _defaultFormDataBuilder,
  }) {
    final usedOptions = _optionsMerge(content, options);
    final usedBody = _bodyMerge(
      content: content,
      options: usedOptions,
      body: body,
      formDataBuilder: formDataBuilder,
    );
    final usedQuery = _mergeQueryParameters(content, queryParameters);

    return request(
      content.uri.toString(),
      data: usedBody,
      queryParameters: usedQuery,
      cancelToken: cancelToken,
      options: usedOptions,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// 使用 RequestContent 進行 download 呼叫
  /// [savePath] 允許以下兩種類型 FutureOr<String> Function(Headers) 或 String
  /// [cancelToken] 取消請求的token
  /// [deleteOnError] 當發生錯誤時是否刪除檔案
  /// [options] content的options將會與此合併, 重複的則以options為主
  /// [lengthHeader] 長度的header
  /// [onReceiveProgress] 接收進度
  /// [formDataBuilder] FormData構建方法, 預設為[_defaultFormDataBuilder], 透過此方法可以自定義FormData的構建方式
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式, 若有帶值, 且為key-value形式, 將會進行合併, 重複的部分將會以body為主
  /// [queryParameters] Query參數, 若此參數為null, 將會使用content的queryParameters, 若有帶值, 將會合併, 重複地將以queryParameters為主
  Future<Response> mxDownload<T>(
    RequestContent content, {
    required dynamic savePath,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
    String lengthHeader = Headers.contentLengthHeader,
    ProgressCallback? onReceiveProgress,
    FormDataBuilder formDataBuilder = _defaultFormDataBuilder,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) {
    final usedOptions = _optionsMerge(content, options);
    final usedBody = _bodyMerge(
      content: content,
      options: usedOptions,
      body: body,
      formDataBuilder: formDataBuilder,
    );
    final usedQuery = _mergeQueryParameters(content, queryParameters);

    return download(
      content.uri.toString(),
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: usedQuery,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: usedBody,
      options: usedOptions,
    );
  }

  /// 合併RequestContent構建的Options與傳入的Options
  Options _optionsMerge(RequestContent content, Options? options) {
    final contentHeader = content.headers != null
        ? Map<String, dynamic>.from(content.headers!)
        : null;

    final contentOptions = Options(
      headers: contentHeader,
      contentType: content.contentType,
      method: content.method,
    );

    final Options usedOptions;

    if (options != null) {
      // 將以options為主
      // 除了headers將會用合併的之外
      // contentType, method將會以options為主, 若無值才默認使用content的
      final newHeaders = <String, dynamic>{
        ...?contentHeader,
        ...?options.headers,
      };

      usedOptions = options.copyWith(
        headers: newHeaders,
        contentType: options.contentType ?? contentOptions.contentType,
        method: options.method ?? contentOptions.method,
      );
    } else {
      usedOptions = contentOptions;
    }

    return usedOptions;
  }

  /// 合併RequestContent構建的Body與傳入的Body
  Object? _bodyMerge({
    required RequestContent content,
    required Options options,
    required Object? body,
    required FormDataBuilder formDataBuilder,
  }) {
    /// 根據contentType, 將body轉為對應的形式
    Object? contentBody;
    Object? usedBody;

    // 若body為null, 則使用content的body
    // 將透過判斷contentType, 將body轉為對應的形式
    final contentType = options.contentType;
    switch (contentType) {
      case Headers.jsonContentType:
        contentBody = content.bodyInRow;
        break;
      case Headers.formUrlEncodedContentType:
        contentBody = content.bodyInKeyValue;
        break;
      case Headers.textPlainContentType:
        contentBody = content.bodyInRow;
        break;
      case Headers.multipartFormDataContentType:
        contentBody = formDataBuilder(content, options);
        break;
      default:
        // 其餘未知的contentType, 不進行轉換
        contentBody = content.body;
        break;
    }

    final isDefaultBodyMap =
        contentBody != null && contentBody is Map<String, dynamic>;
    final isBodyMap = body != null && body is Map<String, dynamic>;

    if (isBodyMap && isDefaultBodyMap) {
      // 相同key將不會用addPair的方式加入, 會使用覆蓋
      usedBody = <String, dynamic>{
        ...contentBody,
        ...body,
      };
    } else if (isBodyMap) {
      usedBody = Map<String, dynamic>.from(body);
    } else if (body == null && isDefaultBodyMap) {
      usedBody = Map<String, dynamic>.from(contentBody);
    } else {
      usedBody = body ?? contentBody;
    }

    return usedBody;
  }

  /// 合併RequestContent構建的QueryParameters與傳入的QueryParameters
  Map<String, dynamic>? _mergeQueryParameters(
    RequestContent content,
    Map<String, dynamic>? queryParameters,
  ) {
    final usedQueryParameters = <String, dynamic>{
      ...?content.queryParameters,
      ...?queryParameters,
    };

    return usedQueryParameters;
  }
}

const _kStartTimeKey = 'mx_time_start';
const _kEndTimeKey = 'mx_time_end';

extension RequestOptionsTimeMx on RequestOptions {
  DateTime? get startTime => extra[_kStartTimeKey] as DateTime?;

  set startTime(DateTime? value) => extra[_kStartTimeKey] = value;

  DateTime? get endTime => extra[_kEndTimeKey] as DateTime?;

  set endTime(DateTime? value) => extra[_kEndTimeKey] = value;
}

extension OptionsTimeMx on Options {
  DateTime? get startTime => extra?[_kStartTimeKey] as DateTime?;

  set startTime(DateTime? value) {
    extra = Map.of(extra ??= <String, dynamic>{});
    extra![_kStartTimeKey] = value;
  }

  DateTime? get endTime => extra?[_kEndTimeKey] as DateTime?;

  set endTime(DateTime? value) {
    extra = Map.of(extra ??= <String, dynamic>{});
    extra![_kEndTimeKey] = value;
  }
}
