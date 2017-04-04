import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'compose/request_compose_component.dart';
import 'cc2/request_cc2_component.dart';
import 'cc3/request_cc3_component.dart';
import 'ts/request_ts_component.dart';
import 'view/request_view_component.dart';
import 'list/request_list_component.dart';

@Component(
    selector: 'requests',
    templateUrl: 'requests_component.html',
    directives: const [RouterLink, RouterOutlet])
@RouteConfig(const [
  const Route(
      path: '',
      component: RequestListComponent,
      name: 'RequestList',
      useAsDefault: true,
      data: RequestListComponent.DisplayName),
  const Route(
      path: '/compose/:contractId/',
      component: RequestComposeComponent,
      name: 'RequestCreate',
      data: RequestComposeComponent.DisplayName),
  const Route(
      path: '/modify/:contractId/:requestId',
      component: RequestComposeComponent,
      name: 'RequestModify',
      data: RequestComposeComponent.DisplayName),
  const Route(
      path: '/view/:contractId/:requestId',
      component: RequestViewComponent,
      name: 'RequestView',
      data: RequestViewComponent.DisplayName),
  const Route(
      path: '/cc2/',
      component: RequestCc2Component,
      name: 'Cc2',
      data: RequestCc2Component.DisplayName),
  const Route(
      path: '/cc3/',
      component: RequestCc3Component,
      name: 'Cc3',
      data: RequestCc3Component.DisplayName),
  const Route(
      path: '/ts/',
      component: RequestTsComponent,
      name: 'Ts',
      data: RequestTsComponent.DisplayName)
])
class RequestsComponent {}
