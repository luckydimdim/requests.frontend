import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

@Injectable()
class InMemoryDataService extends MockClient {
  static final _initialRequests = new List<Object>();
  static final List<Object> _requestsDb = _initialRequests;

  InMemoryDataService() : super(_handler) {
    _initialRequests.add({
      'id': '1',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-ЯСПГ (доп. 2)',
      'contractorName': 'Podryadchik',
      'amount': '300000000',
      'currencyName': 'руб',
      'status': 'approved'
    });
  }

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        final id =
            int.parse(request.url.pathSegments.last, onError: (_) => null);
        if (id != null) {
          data = _requestsDb.firstWhere(
              (contract) => contract.id == id); // throws if no match
        } else {
          data = _requestsDb;
        }
        break;
      case 'POST':
        break;
      case 'PUT':
        break;
      case 'DELETE':
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }

    return new Response(
      JSON.encode(data),
      200,
      headers: {'content-type': 'application/json'});
  }
}
