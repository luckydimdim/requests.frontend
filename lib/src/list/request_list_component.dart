import 'dart:async';
import 'package:angular2/core.dart';

import 'package:grid/grid.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../services/requests_service.dart';
import 'package:requests/src/list/request_model.dart';
import '../pipes/cm_format_money_pipe.dart';

@Component(
  selector: 'request-list',
  templateUrl: 'request_list_component.html',
  providers: const [RequestsService],
  directives: const [
    GridComponent,
    GridTemplateDirective,
    ColumnComponent],
  pipes: const [CmFormatMoneyPipe])
class RequestListComponent implements OnInit, AfterViewInit, OnDestroy {
  static const DisplayName = const { 'displayName': 'Список заявок на проверку' };
  final AsideService _asideService;
  final RequestsService _requestsService;

  var requestsDataSource = new DataSource();

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestListComponent(this._asideService, this._requestsService);

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

    requestsDataSource = new DataSource(data: listMap)
      ..primaryField = 'id';

    return null;
  }

  @override
  ngAfterViewInit() {
    // Добавление в боковую панель компонента выбора договора
    _asideService.addPane(PaneType.ContractSearch);
  }

  /**
   * Показать/скрыть боклвую панель
   */
  togglePane() {
    _asideService.togglePane();
  }

  /**
   * Подставляет нужный css класс в столбце со статусами
   */
  Map<String, bool> resolveStatusStyleClass(String statusSysName) {
    return new Map<String, bool>()..addAll({
      'tag-warning': statusSysName == 'error',
      'tag-success': statusSysName == 'approved',
      'tag-danger': statusSysName == 'deny',
      'tag-primary': statusSysName == 'new'
    });
  }

  @override
  ngOnDestroy() {
    // Удаляется компонент поиска договора из боковой панели
    // перед уходом со страницы с данным компонентом
    _asideService.removePane(PaneType.ContractSearch);
  }
}