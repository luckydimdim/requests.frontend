import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'request-creator',
    templateUrl: 'request_creator_component.html',
    directives: const [RouterLink])
class RequestCreatorComponent {
  static const DisplayName = const { 'displayName': 'Формирование заявки на проверку' };
}