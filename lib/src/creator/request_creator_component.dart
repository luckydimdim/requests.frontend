import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';

import 'package:call_off_order/call_off_service.dart';
import 'package:call_off_order/call_off_order.dart';


@Component(
    selector: 'request-creator',
    templateUrl: 'request_creator_component.html',
    directives: const [
      RouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent])
class RequestCreatorComponent implements OnInit {
  static const DisplayName = const { 'displayName': 'Формирование заявки на проверку' };

  final RouteParams _routeParams;
  final CallOffService _callOffService;
  var callOffsDataSource = new DataSource();
  String contractId = '';

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestCreatorComponent(this._routeParams, this._callOffService);

  @override
  ngOnInit() async {
    contractId = _routeParams.get('id');

    await loadCallOffs();
  }

  Future loadCallOffs() async {
    List<CallOffOrder> orders = await _callOffService.getCallOffOrders(contractId);

    var result = new List<dynamic>();

    for (CallOffOrder order in orders) {
      result.add(order.toMap());
    }

    callOffsDataSource = new DataSource(data: result)
      ..primaryField = 'id';

    return null;
  }
}