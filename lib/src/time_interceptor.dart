import 'package:dio/dio.dart';
import 'package:mx_request/src/dio_extension.dart';

/// 紀錄request的發送時間與結束時間
class TimeInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.startTime = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    response.requestOptions.endTime = DateTime.now();
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    err.requestOptions.endTime = DateTime.now();
    handler.next(err);
  }
}
