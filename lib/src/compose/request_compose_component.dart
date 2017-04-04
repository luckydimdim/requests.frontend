import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:angular_utils/cm_router_link.dart';
import 'package:grid/grid.dart';

import 'package:call_off_order/call_off_service.dart';
import 'package:call_off_order/call_off_order.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../view/detailed_request_model.dart';
import '../view/primary_document.dart';

import '../compose/write_request_model.dart';
import '../services/requests_service.dart';

@Component(
    selector: 'request-compose',
    templateUrl: 'request_compose_component.html',
    providers: const [RequestsService],
    directives: const [
      CmRouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent])
class RequestComposeComponent implements OnInit, OnDestroy {
  static const DisplayName = const { 'displayName': 'Формирование заявки на проверку' };

  final RouteParams _routeParams;
  final CallOffService _callOffService;
  final RequestsService _requestsService;
  final AsideService _asideService;
  final Router _router;

  var callOffsDataSource = new DataSource();
  String contractId = '';
  String requestId = '';
  List<CallOffOrder> callOffOrders = new List<CallOffOrder>();
  List<String> selectedCallOffOrderIds = new List<String>();

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

    _asideService.addPane(PaneType.contractSearch, {
      'router' : _router,
      'contractId': contractId,
      'enabled': createMode == true });

    _asideService.showPane();

    await loadCallOffs();
  }

  /**
   * Загрузка из web-сервиса списка работ
   */
  Future loadCallOffs() async {
    callOffOrders = await _callOffService.getCallOffOrders(contractId);

    var result = new List<dynamic>();

    for (CallOffOrder order in callOffOrders) {
      result.add(order.toMap());
    }

    callOffsDataSource = new DataSource(data: result)
      ..primaryField = 'id';

    // Есди компонент работает в режиме "Редактирование"
    if (!createMode) {
      DetailedRequestModel request = await _requestsService.getRequest(requestId);

      // Восстанавливаем состояние чек-боксов
      for (String callOffOrderId in request.callOffOrderIds) {
        selectedCallOffOrderIds.add(callOffOrderId);
      }
    }

    return null;
  }

  /**
   * Добавляет / удаляет работу из коллекции,
   * которая будет отправлена на web-сервис
   */
  void toggleCallOffOrder(String id) {
    if (!selectedCallOffOrderIds.contains(id))
      selectedCallOffOrderIds.add(id);
    else
      selectedCallOffOrderIds.removeWhere((item) => item == id);
  }

  /**
   * Созданиие заявки: отправка данных на web-сервис
   */
  composeRequest() async {
    var model = new WriteRequestModel()
      ..id = requestId
      ..contractId = contractId
      ..callOffOrderIds = selectedCallOffOrderIds;

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
    _asideService.removePane(PaneType.contractSearch);
  }
}