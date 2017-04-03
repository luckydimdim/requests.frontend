import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';

import 'package:call_off_order/call_off_service.dart';
import 'package:call_off_order/call_off_order.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../compose/write_request_model.dart';
import '../services/requests_service.dart';

@Component(
    selector: 'request-compose',
    templateUrl: 'request_compose_component.html',
    providers: const [RequestsService],
    directives: const [
      RouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent])
class RequestComposeComponent implements OnInit, AfterViewInit, OnDestroy {
  static const DisplayName = const { 'displayName': 'Формирование заявки на проверку' };

  final RouteParams _routeParams;
  final CallOffService _callOffService;
  final RequestsService _requestsService;
  final AsideService _asideService;
  final Router _router;

  var callOffsDataSource = new DataSource();
  String contractId = '';
  String requestId = '';
  List<CallOffOrder> orders = new List<CallOffOrder>();
  List<CallOffOrder> selectedCallOffOrders = new List<CallOffOrder>();

  /**
   * Режим создания / изменения
   */
  bool createMode = true;

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestComposeComponent(this._router, this._routeParams, this._callOffService, this._requestsService, this._asideService);

  @override
  ngOnInit() async {
    contractId = _routeParams.get('contractId');
    requestId = _routeParams.get('requestId');

    // Если id заявки не задано, значит компонент работает в режиме "создания"
    createMode = requestId == null;

    await loadCallOffs();
  }

  /**
   * Загрузка из web-сервиса списка работ
   */
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

  @override
  ngAfterViewInit() {
    // TODO: тут нужно передавать в панель contractId чтобы панель устанавливала
    // нужный договор в состоянии "выбранности",
    // либо блочить выбор договора (для режима modify)
    _asideService.addPane(PaneType.ContractSearch);
  }

  /**
   * Добавляет / удаляет работу из коллекции,
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
  composeRequest() async {
    var ids = new List<String>();

    for (CallOffOrder order in selectedCallOffOrders) {
      ids.add(order.id);
    }

    var model = new WriteRequestModel()
      ..id = requestId
      ..workIds = ids;

    WriteRequestModel newModel = null;

    if (createMode)
      newModel = await _requestsService.createRequest(model);
    else
      newModel = await _requestsService.updateRequest(model);

    _router.navigate(['RequestView', { 'contractId': newModel.contractId, 'requestId': newModel.id }]);
  }

  @override
  ngOnDestroy() {
    // Удаляется компонент поиска договора из боковой панели
    // перед уходом со страницы с данным компонентом
    _asideService.removePane(PaneType.ContractSearch);
  }
}