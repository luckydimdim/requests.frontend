import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:aside/aside_service.dart';

@Component(selector: 'request-list')
@View(
  templateUrl: 'request_list_component.html',
  directives: const [RouterLink])
class RequestListComponent implements AfterViewInit {
  static const DisplayName = const { 'displayName': 'Список заявок' };
  final Router _router;
  final AsideService _asideService;

  RequestListComponent(this._router, this._asideService) {}

  @override
  ngAfterViewInit() {
    //_asideService.addPane();
  }
}