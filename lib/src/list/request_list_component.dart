import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:resources_loader/resources_loader.dart';

@Component(selector: 'request-list')
@View(
  templateUrl: 'request_list_component.html',
  directives: const [RouterLink])
class RequestListComponent implements OnInit {
  static const DisplayName = const { 'displayName': 'Список заявок' };
  final Router _router;
  final ResourcesLoaderService _resourcesLoaderService;

  RequestListComponent(this._router, this._resourcesLoaderService) {}

  void breadcrumbInit(){
  }

  @override
  void ngOnInit() {
    breadcrumbInit();
  }
}