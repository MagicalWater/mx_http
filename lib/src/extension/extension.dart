import 'package:dio/dio.dart';
import 'package:mx_request/src/request_content/request_content.dart';

part 'dio_ex.dart';

part 'request_content_ex.dart';

typedef FormDataBuilder = FormData Function(
  RequestContent content,
  Options options,
);

/// 預設FormData構建方法
FormData _defaultFormDataBuilder(RequestContent content, Options options) {
  return FormData.fromMap(content.bodyInKeyValue ?? {});
}
