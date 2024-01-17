import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final String errMsg =
      'request failed\n Status Code : $statusCode\nReason :  $reasonPhrase';

  return errMsg;
}
