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

import 'write_request_model.dart';
import '../services/requests_service.dart';

@Component(
    selector: 'request-create',
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
class RequestCreateComponent implements OnInit, OnDestroy {
  static const DisplayName = const {
    'displayName': 'Создание заявки на проверку'
  };

  final CallOffService _callOffService;
  final RequestsService _requestsService;
  final AsideService _asideService;
  final Router _router;

  DataSource callOffsDataSource = new DataSource();
  String contractId = '';
  String requestId = '';  // не используется нигде. Используется для подавления предупреждения. TODO: разделить

  /**
   * Работы отсутствуют
   */
  bool isEmpty = false;

  List<CallOffOrder> callOffOrders = new List<CallOffOrder>();
  List<String> selectedCallOffOrderIds = new List<String>();

  /**
   * Режим создания / изменения
   */
  bool createMode = true;

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestCreateComponent(this._router, this._callOffService, this._requestsService, this._asideService);

  @override
  ngOnInit() async {
    Instruction ci = _router.parent.parent.currentInstruction;
    contractId = ci.component.params['id'];

    await loadCallOffs(contractId);

    // Заполнение и добавление боковой панели
    _asideService.addPane(PaneType.contractSearch,
        {'router': _router, 'contractId': contractId, 'enabled': true});

    _asideService.showPane();
  }

  /**
   * Загрузка из web-сервиса списка работ
   */
  Future loadCallOffs(String id) async {
    callOffOrders = await _callOffService.getCallOffOrders(id);

    var result = new List<dynamic>();

    for (CallOffOrder order in callOffOrders) {
      result.add(order.toMap());
    }

    callOffsDataSource = new DataSource(data: result)..primaryField = 'id';

    isEmpty = result.isEmpty;

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
  void toggleAllCallOffOrders(InputElement columnTooglerElement) {
    selectedCallOffOrderIds.clear();

    if (columnTooglerElement.checked) {
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
      ..contractId = contractId
      ..callOffOrderIds = selectedCallOffOrderIds;

    WriteRequestModel newModel = null;

    newModel = await _requestsService.createRequest(model);

    _router.parent.navigate([
      'Request',
      {'id': newModel.id}
    ]);
  }

  @override
  ngOnDestroy() {
    // Удаляется компонент поиска договора из боковой панели
    // перед уходом со страницы с данным компонентом
    _asideService.removePane(PaneType.contractSearch);
  }

 }