import 'package:dio/dio.dart';
import 'request_content/request_content.dart';

typedef FormDataBuilder = FormData Function(
  RequestContent content,
  Options options,
);

/// 預設FormData構建方法
FormData _defaultFormDataBuilder(RequestContent content, Options options) {
  return FormData.fromMap(content.bodyInKeyValue ?? {});
}

extension DioEx on Dio {
  /// 使用 HttpContent 進行 request 呼叫
  /// [options] 請求函數, content的options將會與此合併, 重複的則以options為主
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式
  /// [cancelToken] 取消請求的token
  /// [onSendProgress] 發送進度
  /// [onReceiveProgress] 接收進度
  /// [formDataBuilder] FormData構建方法, 預設為[_defaultFormDataBuilder], 透過此方法可以自定義FormData的構建方式
  Future<Response<T>> connect<T>(
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
      options: options ?? contentOptions,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
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
