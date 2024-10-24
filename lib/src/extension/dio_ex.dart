part of 'extension.dart';

extension DioEx on Dio {
  /// 使用 RequestContent 進行 request 呼叫
  /// [options] content的options將會與此合併, 重複的則以options為主
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式
  /// [cancelToken] 取消請求的token
  /// [onSendProgress] 發送進度
  /// [onReceiveProgress] 接收進度
  /// [formDataBuilder] FormData構建方法, 預設為[_defaultFormDataBuilder], 透過此方法可以自定義FormData的構建方式
  Future<Response<T>> mxRequest<T>(
      RequestContent content, {
        Object? body,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        FormDataBuilder formDataBuilder = _defaultFormDataBuilder,
      }) {
    final contentOptions = Options(
      headers: content.headers,
      contentType: content.contentType,
      method: content.method,
    );

    if (options != null) {
      // 將以options為主
      // 除了headers將會用合併的之外
      // contentType, method將會以options為主, 若無值才默認使用content的
      if (options.headers != null) {
        options.headers!.addAll(contentOptions.headers ?? {});
      } else {
        options.headers = contentOptions.headers;
      }
      options.contentType = options.contentType ?? contentOptions.contentType;
      options.method = options.method ?? contentOptions.method;
    }

    final usedOptions = options ?? contentOptions;

    Object? usedBody;

    if (body == null) {
      // 若body為null, 則使用content的body
      // 將透過判斷contentType, 將body轉為對應的形式
      final contentType = usedOptions.contentType;
      switch (contentType) {
        case Headers.jsonContentType:
          usedBody = content.bodyInRow;
          break;
        case Headers.formUrlEncodedContentType:
          usedBody = content.bodyInKeyValue;
          break;
        case Headers.textPlainContentType:
          usedBody = content.bodyInRow;
          break;
        case Headers.multipartFormDataContentType:
          usedBody = formDataBuilder(content, usedOptions);
          break;
        default:
        // 其餘未知的contentType, 不進行轉換
          usedBody = content.body;
          break;
      }
    } else {
      usedBody = body;
    }

    return requestUri(
      content.uri,
      data: usedBody,
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
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式
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
      }) {
    final contentOptions = Options(
      headers: content.headers,
      contentType: content.contentType,
      method: content.method,
    );

    if (options != null) {
      // 將以options為主
      // 除了headers將會用合併的之外
      // contentType, method將會以options為主, 若無值才默認使用content的
      if (options.headers != null) {
        options.headers!.addAll(contentOptions.headers ?? {});
      } else {
        options.headers = contentOptions.headers;
      }
      options.contentType = options.contentType ?? contentOptions.contentType;
      options.method = options.method ?? contentOptions.method;
    }

    final usedOptions = options ?? contentOptions;

    Object? usedBody;

    if (body == null) {
      // 若body為null, 則使用content的body
      // 將透過判斷contentType, 將body轉為對應的形式
      final contentType = usedOptions.contentType;
      switch (contentType) {
        case Headers.jsonContentType:
          usedBody = content.bodyInRow;
          break;
        case Headers.formUrlEncodedContentType:
          usedBody = content.bodyInKeyValue;
          break;
        case Headers.textPlainContentType:
          usedBody = content.bodyInRow;
          break;
        case Headers.multipartFormDataContentType:
          usedBody = formDataBuilder(content, usedOptions);
          break;
        default:
        // 其餘未知的contentType, 不進行轉換
          usedBody = content.body;
          break;
      }
    } else {
      usedBody = body;
    }

    return downloadUri(
      content.uri,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: usedBody,
      options: usedOptions,
    );
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
