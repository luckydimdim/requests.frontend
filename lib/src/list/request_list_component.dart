import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';
import 'package:angular_utils/cm_format_money_pipe.dart';
import 'package:angular_utils/cm_format_currency_pipe.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../services/requests_service.dart';
import '../request_utils.dart';
import 'package:requests/src/list/request_model.dart';

@Component(
    selector: 'request-list',
    templateUrl: 'request_list_component.html',
    providers: const [RequestsService],
    directives: const [GridComponent, GridTemplateDirective, ColumnComponent],
    pipes: const [CmFormatMoneyPipe, DatePipe, CmFormatCurrencyPipe])
class RequestListComponent implements OnInit, AfterViewInit, OnDestroy {
  static const DisplayName = const {'displayName': 'Список заявок на проверку'};
  final AsideService _asideService;
  final RequestsService _requestsService;
  final Router _router;

  DataSource requestsDataSource;

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestListComponent(this._asideService, this._requestsService, this._router);

  @override
  Future ngOnInit() async {
    await loadRequests();
  }

  /**
   * Получение списка заявок на проверку
   */
  Future loadRequests() async {
    List<RequestModel> requests = await _requestsService.getRequests();

    var listMap = new List<Map<String, String>>();
    for (RequestModel request in requests) {
      listMap.add(request.toMap());
    }

    requestsDataSource = new DataSource(data: listMap)..primaryField = 'id';

    return null;
  }

  @override
  ngAfterViewInit() {
    // Добавление в боковую панель компонента выбора договора
    _asideService.addPane(PaneType.contractSearch, {'router': _router});
  }

  /**
   * Показать/скрыть боклвую панель
   */
  showPane() {
    _asideService.showPane();
  }

  /**
   * Подставляет нужный css класс в столбце со статусами
   */
  Map<String, bool> resolveStatusStyleClass(String statusSysName) {
    return RequestUtils.resolveStatusStyleClass(statusSysName);
  }

  @override
  ngOnDestroy() {
    // Удаляется компонент поиска договора из боковой панели
    // перед уходом со страницы с данным компонентом
    _asideService.removePane(PaneType.contractSearch);
  }

  /**
   * Переход к просмотру заявки
   */
  void viewRequest(String requestId) {
    _router.navigate([
      'Request',
      {'id': requestId}
    ]);
  }

  /**
   * Удаление заявки
   */
  deleteRequest(String id) async {
    if (!window.confirm('Удалить заявку?')) return;

    await _requestsService.deleteRequest(id);

    requestsDataSource.data.removeWhere((item) => item['id'] == id);
  }

  /**
   * Переход к редактированию заявки
   */
  editRequest(String requestId) {
    _router.navigate([
      'Request',
      {'id': requestId},
      'RequestModify'
    ]);
  }

  bool isReadOnly(dynamic rowData) {
    String statusSysName = rowData['statusSysName'];

    if (statusSysName == null || statusSysName == '') return true;

    statusSysName = statusSysName.toUpperCase();

    if (statusSysName == 'APPROVED' || statusSysName == 'APPROVING')
      return true;

    return false;
  }
}
