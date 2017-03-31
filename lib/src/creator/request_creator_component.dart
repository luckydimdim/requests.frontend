import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';

import 'package:call_off_order/call_off_service.dart';
import 'package:call_off_order/call_off_order.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../request_model.dart';
import '../services/requests_service.dart';


@Component(
    selector: 'request-creator',
    templateUrl: 'request_creator_component.html',
    providers: const [RequestsService],
    directives: const [
      RouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent])
class RequestCreatorComponent implements OnInit, AfterViewInit {
  static const DisplayName = const { 'displayName': 'Формирование заявки на проверку' };

  final RouteParams _routeParams;
  final CallOffService _callOffService;
  final RequestsService _requestsService;
  final AsideService _asideService;

  var callOffsDataSource = new DataSource();
  String contractId = '';
  List<CallOffOrder> orders = new List<CallOffOrder>();
  List<CallOffOrder> selectedCallOffOrders = new List<CallOffOrder>();

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestCreatorComponent(this._routeParams, this._callOffService, this._requestsService, this._asideService);

  @override
  ngOnInit() async {
    contractId = _routeParams.get('id');

    await loadCallOffs();
  }

  @override
  ngAfterViewInit() {
    _asideService.addPane(PaneType.ContractSearch);
  }

  Future loadCallOffs() async {
    orders = await _callOffService.getCallOffOrders(contractId);

    var result = new List<dynamic>();

    for (CallOffOrder order in orders) {
      result.add(order.toMap());
    }

    callOffsDataSource = new DataSource(data: result)
      ..primaryField = 'id';

    return null;
  }

  /**
   * Добавляет/удаляет работу из коллекции,
   * которая будет отправлена на web-сервис
   */
  void toggleCallOffOrder(String id) {
    CallOffOrder order = selectedCallOffOrders.firstWhere(
        (order) => order.id == id, orElse: () => null);

    if (order == null)
      selectedCallOffOrders.add(orders.firstWhere((order) => order.id == id));
    else
      selectedCallOffOrders.removeWhere((order) => order.id == id);
  }

  /**
   * Созданиие заявки: отправка данных на web-Сервис
   */
  createRequest() async {
    var ids = new List<String>();

    for (CallOffOrder order in selectedCallOffOrders) {
      ids.add(order.id);
    }

    var model = new RequestModel()
      ..contractId = contractId
      ..workIds = ids;

    await _requestsService.createRequest(model);
  }
}