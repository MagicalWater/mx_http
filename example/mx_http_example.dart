import 'package:mx_http/mx_http.dart';

import 'request.dart';

void main() async {
  // 初始化http請求工具
  final httpUtil = HttpUtil();

  // 初始化api接口實體
  final request = ExRequest();

  // 發出http api請求, 並取得響應
  final response = await request
      .exApi(
        'apiPath',
        'hi',
        'bToken',
        'cBody',
        MultipartFile.fromString('value'),
        check: 'check',
        opId: 'opId',
        opId2: ['opId2'],
      )
      .connect(httpUtil)
      .then((value) => value.getString());
}
