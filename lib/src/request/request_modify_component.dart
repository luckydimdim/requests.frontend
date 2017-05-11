import 'dart:async';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:angular_utils/cm_router_link.dart';
import 'package:grid/grid.dart';

import 'package:call_off_order/call_off_service.dart';
import 'package:call_off_order/call_off_order.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import 'detailed_request_model.dart';

import 'write_request_model.dart';
import '../services/requests_service.dart';

@Component(
    selector: 'request-modify',
    templateUrl: 'request_compose_component.html',
    providers: const [
      RequestsService
    ],
    directives: const [
      CmRouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent
    ])
class RequestModifyComponent implements OnInit, OnDestroy {
  static const DisplayName = const {'displayName': 'Правка заявки на проверку'};

  final CallOffService _callOffService;
  final RequestsService _requestsService;
  final AsideService _asideService;
  final Router _router;

  DataSource callOffsDataSource = new DataSource();
  String contractId = '';
  String requestId = '';

  /**
   * Работы отсутствуют
   */
  bool isEmpty = false;

  List<CallOffOrder> callOffOrders = new List<CallOffOrder>();
  List<String> selectedCallOffOrderIds = new List<String>();

  /**
   * Режим создания / изменения
   */
  final bool createMode = false;

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestModifyComponent(this._router, this._callOffService,
      this._requestsService, this._asideService);

  @override
  ngOnInit() async {
    Instruction ci = _router.parent.parent.currentInstruction;
    String id = ci.component.params['id'];

    await loadCallOffs(id);

    // Загрузка и добавление боковой панели
    _asideService.addPane(PaneType.contractSearch,
        {'router': _router, 'contractId': contractId, 'enabled': false});

    _asideService.showPane();
  }

  /**
   * Загрузка из web-сервиса списка работ
   */
  Future loadCallOffs(String id) async {
    DetailedRequestModel request = await _requestsService.getRequest(id);

    // Восстанавливаем состояние чек-боксов
    for (String callOffOrderId in request.callOffOrderIds) {
      toggleCallOffOrder(callOffOrderId);
    }

    callOffOrders = await _callOffService.getCallOffOrders(request.contractId);

    var result = new List<dynamic>();

    for (CallOffOrder order in callOffOrders) {
      result.add(order.toMap());
    }

    callOffsDataSource = new DataSource(data: result)..primaryField = 'id';

    isEmpty = result.isEmpty;

    requestId = request.id;
    contractId = request.contractId;

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
   * Проверяет, являются ли все работы выбранными
   */
  bool isAllCallOffOrdersSelected() {
    if ((selectedCallOffOrderIds.length == callOffOrders.length) &&
        callOffOrders.length > 0)
      return true;
    else
      return false;
  }

  /**
   * Проверяет, является ли указанная работа выбранной
   */
  bool isCallOffOrderSelected(String id) {
    return selectedCallOffOrderIds.contains(id);
  }

  /**
   * Добавляет / удаляет все работы
   */
  void toggleAllCallOffOrders(InputElement columnTogglerElement) {
    selectedCallOffOrderIds.clear();

    if (columnTogglerElement.checked) {
      for (CallOffOrder order in callOffOrders) {
        selectedCallOffOrderIds.add(order.id);
      }
    }
  }

  void rowClicked(dynamic rowData) {
    toggleCallOffOrder(rowData['id']);
  }

  /**
   * Созданиие заявки: отправка данных на web-сервис
   */
  composeRequest() async {
    var model = new WriteRequestModel()
      ..id = requestId
      ..contractId = contractId
      ..callOffOrderIds = selectedCallOffOrderIds;

    await _requestsService.updateRequest(model);

    _router.parent.navigate([
      'Request',
      {'id': requestId}
    ]);
  }

  @override
  ngOnDestroy() {
    // Удаляется компонент поиска договора из боковой панели
    // перед уходом со страницы с данным компонентом
    _asideService.removePane(PaneType.contractSearch);
    _asideService.hidePane();
  }

  /**
   * Перейти к разделу создания работ
   */
  void goToContractWorks(contractId) {
    // TODO: implement
  }
}
