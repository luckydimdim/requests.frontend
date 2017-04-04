import 'dart:core';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/src/core/reflection/reflection.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:requests/in_memory_data_service.dart';

import 'package:logger/logger_service.dart';
import 'package:config/config_service.dart';
import 'package:alert/alert_service.dart';
import 'package:aside/aside_service.dart';
import 'package:angular_utils/cm_router_link.dart';

import 'package:master_layout/master_layout_component.dart';

import 'package:requests/requests_component.dart';

import 'package:contracts/contracts_service.dart';
import 'package:contracts/contract_general_service.dart';

import 'package:call_off_order/call_off_service.dart';

bool get isDebug =>
    (const String.fromEnvironment('PRODUCTION', defaultValue: 'false')) !=
    'true';

@Component(selector: 'app', providers: const [
  ROUTER_PROVIDERS,
  const Provider(LocationStrategy, useClass: HashLocationStrategy)],
  template: '<master-layout><requests></requests></master-layout>',
  directives: const [
    MasterLayoutComponent,
    RequestsComponent,
    RouterOutlet,
    CmRouterLink])
@RouteConfig(const [
const Route(
  path: '...',
  component: RequestsComponent,
  name: 'Requests',
  useAsDefault: true)])
class AppComponent {
  AppComponent() {}
}

main() async {
  if (isDebug) {
    reflector.trackUsage();
  }

  ComponentRef ref = await bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    const Provider(LocationStrategy, useClass: HashLocationStrategy),
    const Provider(AlertService),
    const Provider(AsideService),
    const Provider(LoggerService),
    const Provider(ConfigService),
    const Provider(ContractsService),
    const Provider(ContractGeneralService),
    const Provider(CallOffService),
    // provide(Client, useClass: InMemoryDataService)
    // Using a real back end?
    // Import browser_client.dart and change the above to:
    provide(Client, useFactory: () => new BrowserClient(), deps: [])
  ]);

  if (isDebug) {
    print('Application in DebugMode');
    enableDebugTools(ref);
    print('Unused keys: ${reflector.listUnusedKeys()}');
  }
}