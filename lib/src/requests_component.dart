import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:call_off_order/call_off_service.dart';

import 'list/request_list_component.dart';
import 'request/request_component.dart';

@Component(
    selector: 'requests',
    templateUrl: 'requests_component.html',
    directives: const [RouterLink, RouterOutlet],
    providers: const [CallOffService])
@RouteConfig(const [
  const Route(
      path: '',
      component: RequestListComponent,
      name: 'RequestList',
      useAsDefault: true,
      data: RequestListComponent.DisplayName),
  const Route(
      path: '/:id/...',
      component: RequestComponent,
      name: 'Request',
      data: RequestComponent.DisplayName)
])
class RequestsComponent {
  static const DisplayName = const {'displayName': 'Заявки'};
}
