part of 'extension.dart';

extension RequestContentEx on RequestContent {
  /// 使用 RequestContent 進行 request 呼叫
  /// [body] Body, 若此參數為null, 將會使用content的body, 透過content-type自動解析取得body應該有的形式
  /// [queryParameters] Query參數, 若此參數為null, 將會使用content的queryParameters, 若有帶值, 將會合併, 重複地將以queryParameters為主
  /// [cancelToken] 取消請求的token
  /// [options] content的options將會與此合併, 重複的則以options為主
  /// [onSendProgress] 發送進度
  /// [onReceiveProgress] 接收進度
  /// [formDataBuilder] FormData構建方法, 預設為[_defaultFormDataBuilder], 透過此方法可以自定義FormData的構建方式
  Future<Response<T>> request<T>(
    Dio dio, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    FormDataBuilder formDataBuilder = _defaultFormDataBuilder,
  }) {
    return dio.mxRequest<T>(
      this,
      body: body,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      formDataBuilder: formDataBuilder,
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
  /// [queryParameters] Query參數, 若此參數為null, 將會使用content的queryParameters, 若有帶值, 將會合併, 重複地將以queryParameters為主
  Future<Response> mxDownload<T>(
    Dio dio, {
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
    return dio.mxDownload<T>(
      this,
      savePath: savePath,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      options: options,
      lengthHeader: lengthHeader,
      onReceiveProgress: onReceiveProgress,
      formDataBuilder: formDataBuilder,
      body: body,
      queryParameters: queryParameters,
    );
  }
}
