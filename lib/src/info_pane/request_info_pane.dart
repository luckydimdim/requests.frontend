import 'package:angular2/core.dart';
import 'package:angular_utils/directives.dart';
import 'package:angular_utils/pipes.dart';
import '../request/detailed_request_model.dart';

@Component(
    selector: 'request-info-pane',
    templateUrl: 'request_info_pane.html',
    pipes: const [CmFormatMoneyPipe],
    directives: const [CmRouterLink])
class RequestInfoPaneComponent implements OnInit {
  @Input()
  DetailedRequestModel model;

  @Input()
  bool readOnly = false;

  @override
  ngOnInit() async {}
}