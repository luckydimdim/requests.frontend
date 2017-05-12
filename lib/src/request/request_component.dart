import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:time_sheet/time_sheet_component.dart';

import 'cc2/request_cc2_component.dart';
import 'cc3/request_cc3_component.dart';

import 'request_create_component.dart';
import 'request_modify_component.dart';
import 'request_view_component.dart';

@Component(
    selector: 'request',
    templateUrl: 'request_component.html',
    directives: const [RouterOutlet, TimeSheetComponent])
@RouteConfig(const [
  const Route(
      path: '',
      component: RequestViewComponent,
      name: 'RequestView',
      data: RequestViewComponent.DisplayName,
      useAsDefault: true),
  const Route(
      path: 'time-sheets',
      component: RequestViewComponent,
      name: 'RequestTimeSheetsView',
      data: RequestViewComponent.DisplayName),
  const Route(
      path: 'modify',
      component: RequestModifyComponent,
      name: 'RequestModify',
      data: RequestModifyComponent.DisplayName),
  const Route(
      path: 'create',
      component: RequestCreateComponent,
      name: 'RequestCreate',
      data: RequestCreateComponent.DisplayName),
  const Route(
      path: '/time-sheets/:id',
      component: TimeSheetComponent,
      name: 'TimeSheet',
      data: TimeSheetComponent.DisplayName),
  const Route(
      path: 'cc2',
      component: RequestCc2Component,
      name: 'Cc2',
      data: RequestCc2Component.DisplayName),
  const Route(
      path: 'cc3',
      component: RequestCc3Component,
      name: 'Cc3',
      data: RequestCc3Component.DisplayName)
])
class RequestComponent {
  static const DisplayName = const {'displayName': 'Заявка на проверку'};
}
