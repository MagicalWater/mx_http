import 'package:mx_http/mx_http.dart';
import 'dart:io';

part 'request.api.dart';

/// 運行以下命令生成api實體
/// dart pub run build_runner build
@Api()
abstract class ExRequestInterface {
  @Post(
    'ex/{titlePath}{check}',
    headers: {
      'titleHKey': 'titleHValue',
    },
    queryParams: {
      'titleQPKey': 'titleQPValue',
    },
    body: {
      'titleBodyKey': 'titleBodyValue',
    },
    bodyType: HttpBodyType.formUrlencoded,
    contentType: HttpContentType.formUrlencoded,
    // host: 'titleHost',
    // scheme: 'titleHttps',
    port: 8881,
  )
  HttpContent exApi(
    @Path('titlePath') String titlePath,
    @Param('id') String? aId,
    @Header('toke¥n') String bToken,
    @Body('body') String cBody,
    // @Body() String rawBody,
    @Body('bodyF') MultipartFile dBodyFile, {
    @Path('check') required String check,
    @Param('opId') required String? opId,
    @Header('tokenOp') String? opToken,
    @Body('bodyOp') String? opBody,
    @Body('bodyFOp') MultipartFile? opBodyFile,
    // @Body() String? optRawBody,
    @Param('opId2') required List<String> opId2,
  });
}

class ExRequest extends ExRequestApi {
  @override
  String host() => 'www.google.com';

  @override
  String scheme() => 'https';
}
