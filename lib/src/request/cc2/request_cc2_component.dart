import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:intl/intl.dart';

import 'package:resources_loader/resources_loader.dart';

@Component(selector: 'cc2', templateUrl: 'request_cc2_component.html')
class RequestCc2Component implements AfterViewInit, OnInit {
  static const DisplayName = const {'displayName': 'КС-2'};
  static const String route_name = 'Cc2';
  static const String route_path = 'cc-2/:objectName/:contractorName';
  static const Route route = const Route(
      path: RequestCc2Component.route_path,
      component: RequestCc2Component,
      name: RequestCc2Component.route_name);

  final Router _router;
  final ResourcesLoaderService _resourcesLoaderService;
  final RouteParams _routeParams;

  RequestCc2Component(
      this._router, this._resourcesLoaderService, this._routeParams);

  void breadcrumbInit() {
    var breadcrumbContent = querySelector('#breadcrumbContent') as HtmlElement;

    if (breadcrumbContent == null) return;

    breadcrumbContent.innerHtml = '''
            <li class="breadcrumb-item"><a href="#/master/dashboard">Главная</a></li>
            <li class="breadcrumb-item"><a href="#/master/requestList">Список заявок</a></li>
            <li class="breadcrumb-item"><a href="#/master/request">Создание заявки</a></li>
            <li class="breadcrumb-item"><a href="#/master/request/view">Первичная документация</a></li>
            <li class="breadcrumb-item active">Акт КС-2 по объекту &laquo;Морской порт&raquo; подрядчика &laquo;Подрядчик раз два три&raquo;</li>
    ''';
  }

  @override
  ngOnInit() {
    breadcrumbInit();
    String objectName = _routeParams.get('objectName');
    String contractorName = _routeParams.get('contractorName');
  }

  @override
  void ngAfterViewInit() {
    // TODO: Продумать показ/скрытие меню
    document.body.classes.remove('mobile-open');
    document.body.classes.remove('aside-menu-open');

    _resourcesLoaderService.loadScript(
        'vendor/moment/min/', 'moment.min.js', false);

    _resourcesLoaderService.loadScript(
        'vendor/bootstrap-daterangepicker/', 'daterangepicker.js', false);

    _resourcesLoaderService.loadStyle(
        'vendor/bootstrap-daterangepicker/', 'daterangepicker.css');

    var printButtonList =
        querySelectorAll('[print-cc2]') as List<ButtonElement>;
    printButtonList.forEach((ButtonElement button) {
      button.onClick.listen((MouseEvent e) {
        window.open('/packages/request/src/cc2/cc2.pdf', '_blank');
      });
    });

    final formatter = new NumberFormat('###,###.##', 'ru_RU');

    var table = querySelector('[calculation-table]') as TableElement;
    table.rows.forEach((TableRowElement row) {
      var priceCell =
          row.querySelector('[data-unit-price]') as TableCellElement;
      var quantityInput =
          row.querySelector('[data-unit-quantity]') as InputElement;
      var totalCell = row.querySelector('[data-total]') as TableCellElement;

      if (totalCell != null) {
        quantityInput.onKeyPress.listen((Event e) {
          var newQuantity = e.currentTarget as InputElement;

          totalCell.innerHtml =
              '${formatter.format(int.parse(priceCell.innerHtml, onError:(_) => 0) * int.parse(newQuantity.value, onError: (_) => 0))} р.';
        });
      }
    });
  }
}
