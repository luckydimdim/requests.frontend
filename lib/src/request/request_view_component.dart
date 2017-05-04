import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:angular_utils/directives.dart';
import 'package:grid/grid.dart';

import 'package:angular_utils/cm_format_money_pipe.dart';
import 'package:angular_utils/cm_format_currency_pipe.dart';

import '../services/requests_service.dart';
import '../info_pane/contract_info_pane.dart';
import 'request_status.dart';
import 'detailed_request_model.dart';
import 'primary_document.dart';

@Component(
    selector: 'view',
    templateUrl: 'request_view_component.html',
    providers: const [
      RequestsService
    ],
    directives: const [
      CmRouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent,
      ContractInfoPaneComponent
    ],
    pipes: const [
      CmFormatMoneyPipe, CmFormatCurrencyPipe
    ])
class RequestViewComponent implements OnInit, AfterViewInit {
  static const DisplayName = const {'displayName': 'Документация'};

  final Router _router;

  /**
   * Первичные документы отсутствуют
   */
  bool listIsEmpty = false;

  /**
   * Имеются незаполненные табели
   */
  bool hasEmptyTimeSheets = false;

  /**
   * Все табели согласованы
   */
  bool allTimeSheetsAreApproved = false;

  DataSource worksDataSource = new DataSource();
  final RequestsService _requestsService;

  String contractId = '';
  String requestId = '';
  DetailedRequestModel model = new DetailedRequestModel();

  bool readOnly = true;

  @ViewChild(GridComponent)
  GridComponent grid;

  RequestViewComponent(this._router, this._requestsService);

  @override
  ngOnInit() async {
    Instruction ci = _router.parent.parent.currentInstruction;
    String id = ci.component.params['id'];

    await _loadRequest(id);
  }

  /**
   * Загрузака из web-сервиса данных по заявке на проверку
   */
  Future _loadRequest(String id) async {
    model = await _requestsService.getRequest(id);

    requestId = model.id;
    contractId = model.contractId;

    List<Map<String, String>> documentMaps = new List<Map<String, String>>();

    for (PrimaryDocument document in model.documents) {
      documentMaps.add(document.toMap());
    }

    worksDataSource = new DataSource(data: documentMaps)..primaryField = 'id';

    hasEmptyTimeSheets = worksDataSource.data.firstWhere((x) => x['statusSysName']?.toUpperCase() == 'EMPTY', orElse: () => null) != null;
    allTimeSheetsAreApproved = worksDataSource.data.firstWhere((x) => x['statusSysName']?.toUpperCase() != 'DONE', orElse: () => null) == null;
    listIsEmpty = model.documents.isEmpty;

    var statusSysName = model.statusSysName.toUpperCase();

    if (statusSysName == 'DONE' || statusSysName == 'VALIDATION')
      readOnly = true;
    else
      readOnly = false;

    return null;
  }

  @override
  void ngAfterViewInit() {
    window.scrollTo(0, 0);

    sticky();
  }

  /**
   * Фиксация боковой панели
   */
  void sticky() {
    var pane = querySelector('[sticky]');
    if (pane == null) return;

    var width = pane.getComputedStyle().width;

    // При ресайзе окна ширина панели
    // подстраивается под ширину родительского элемента
    window.onResize.listen((Event e) {
      var stickyElement = querySelector('[sticky]');

      if (stickyElement == null) return;

      width = stickyElement.parent.clientWidth;

      var paddingLeft = stickyElement.parent
          .getComputedStyle()
          .paddingLeft
          .replaceAll('px', '');
      var paddingRight = stickyElement.parent
          .getComputedStyle()
          .paddingRight
          .replaceAll('px', '');

      var pl = int.parse(paddingLeft);
      var pr = int.parse(paddingRight);

      width = width - pl - pr;

      stickyElement.style.width = width.toString() + 'px';
    });

    bool topWasSet = false;

    /*window.onMouseWheel.listen((Event e) {
      print(e.offset.y);
    });*/

    // При прокрутке окна устанавливается position: fixed
    window.onScroll.listen((Event e) {
      if (window.pageXOffset > 0) return;

      // Флаг включенности "режима прилипания"
      bool enabled = false;

      // Высота шапки
      const headerHeight = 55;

      // Отступ родительского элемента
      const navTopPadding = 15;

      // Контейнер, содержимое которого прилипает
      var sticky = querySelector('[sticky]') as HtmlElement;
      if (sticky == null) return;

      // Верхняя отметка, до которой не нужно начинать прилипание
      var stickyTop = querySelector('[sticky-top]') as HtmlElement;
      if (stickyTop != null) {
        enabled = stickyTop.getBoundingClientRect().top - headerHeight <= 0;
      } else {
        enabled = window.pageYOffset > 0;
      }

      if (enabled) {
        if (!topWasSet) {
          // FIXME: при скроле колесом криво считается отступ сверху
          sticky.style.top =
              '${stickyTop.getBoundingClientRect().top + navTopPadding}px';
          topWasSet = true;
        }

        sticky.style.position = 'fixed';
        sticky.style.width = width.toString();
      } else {
        if (topWasSet) {
          sticky.style.top = '0';
          topWasSet = false;
        }

        sticky.style.position = 'relative';
      }
    });
  }

  /**
   * Обработка нажатия на кнопку "Отправить на согласование"
   */
  Future publish() async {
    await _requestsService.setStatus(requestId, RequestStatus.validation);

    _router.navigate(['../../RequestList',]);
  }

  /**
   * Подставляет нужный css класс в столбце со статусами
   */
  Map<String, bool> resolveStatusStyleClass(String statusSysName) {
    String status = statusSysName.toUpperCase();

    return new Map<String, bool>()
      ..addAll({
        'tag-default': status == 'EMPTY',
        'tag-warning': status == 'VALIDATION',
        'tag-success': status == 'DONE',
        'tag-danger': status == 'CORRECTION',
        'tag-primary': (status == 'CREATION' || status == 'CREATING')
      });
  }

  /**
   * Переход к просмотру Time sheet'a
   */
  void goToDocument(String id) {
    _router.navigate(['TimeSheet', { 'id': id }]);
  }
}