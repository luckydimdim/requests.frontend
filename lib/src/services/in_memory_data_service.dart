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
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '2',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '3',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '4',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'deny',
      'statusSysName': 'deny'
    });
    _initialRequests.add({
      'id': '5',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'new',
      'statusSysName': 'new'
    });
    _initialRequests.add({
      'id': '6',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'errors',
      'statusSysName': 'error'
    });
  }

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        final id = int.parse(request.url.pathSegments.last, onError: (_) => null);
        if (id != null) {
          data = _requestsDb.firstWhere(
              (item) => item.id == id); // throws if no match
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

    String responseData = JSON.encode(data);

    return new Response(
      responseData,
      200,
      headers: {'content-type': 'application/json'});
  }
}