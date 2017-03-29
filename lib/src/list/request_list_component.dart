import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

@Component(
  selector: 'request-list',
  templateUrl: 'request_list_component.html',
  directives: const [
    GridComponent,
    GridTemplateDirective,
    ColumnComponent])
class RequestListComponent implements OnInit, AfterViewInit {
  static const DisplayName = const { 'displayName': 'Список заявок на проверку' };
  final Router _router;
  final AsideService _asideService;
  final RequestsService _requestsService;

  RequestListComponent(this._router, this._asideService, this._requestsService);

  @override
  Future ngOnInit() async {
    await loadCallOffOrders();
  }

  Future loadCallOffOrders() async {
    List<RequestModel> requests =
    await _callOffService.getCallOffOrders(contractId);

    var result = new List<dynamic>();

    for (CallOffOrder order in orders) {
      result.add(order.toMap());
    }

    worksDataSource = new DataSource(result)..primaryField = 'id';

    return null;
  }

  @override
  ngAfterViewInit() {
    _asideService.addPane(PaneType.ContractSearch);
  }

  /**
   * Показать/скрыть боклвую панель
   */
  togglePane() {
    _asideService.togglePane();
  }
}