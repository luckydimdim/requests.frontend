import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';

import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

import '../service/requests_service.dart';
import '../request_model.dart';

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

  var requestsDataSource = new DataSource();

  RequestListComponent(this._router, this._asideService, this._requestsService);

  @override
  Future ngOnInit() async {
    await loadRequests();
  }

  Future loadRequests() async {
    List<RequestModel> requests = await _requestsService.getRequests();

    var result = new List<dynamic>();

    for (RequestModel request in requests) {
      result.add(request.toMap());
    }

    requestsDataSource = new DataSource(data: result)
      ..primaryField = 'id';

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