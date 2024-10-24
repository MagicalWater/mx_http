import 'package:mx_request/mx_request.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  final content = RequestContent(
    scheme: 'https',
    host: 'google.com',
    method: RequestMethods.get,
    contentType: Headers.formUrlEncodedContentType,
  );

  // content.addHeader('Header1', value: 'Header1Value');
  // content.addQuery('Query1', value: 'Query1Value');
  // content.addBodyInKeyValue('BodyKV1', value: 'BodyKV1Value');

  final dio = Dio();
  await content.request(dio).then((value) {
    print('Response: $value');
  }).catchError((e, s) {
    print('Error: $e');
  });
}
