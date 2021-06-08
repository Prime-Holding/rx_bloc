import 'dart:convert';
import 'package:shelf/shelf.dart';

class ResponseBuilder {
  Response buildUnprocessableEntity(Exception exception) => Response(
        422,
        body: const JsonEncoder.withIndent(' ').convert({
          'type': 'https://example/errors/missing-property',
          'status': 422,
          'title': exception.toString().replaceAll('Exception: ', '')
        }),
        headers: {
          'content-type': 'application/problem+json',
        },
      );

  Response buildOK(Map<String, dynamic> data) => Response.ok(
        const JsonEncoder.withIndent(' ').convert(data),
        headers: {
          'content-type': 'application/json',
        },
      );
}
