import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Component(selector: 'request-ts', templateUrl: 'request_ts_component.html')
class RequestTsComponent implements AfterViewInit {
  static const DisplayName = const { 'displayName': 'Табель' };
  static const String route_name = 'RequestTs';
  static const String route_path = 'time-sheet';
  static const Route route = const Route(
    path: RequestTsComponent.route_path,
    component: RequestTsComponent,
    name: RequestTsComponent.route_name);

  final Router _router;

  RequestTsComponent(this._router) {}

  void breadcrumbInit() {
    var breadcrumbContent = querySelector('#breadcrumbContent') as HtmlElement;

    if (breadcrumbContent == null)
      return;

    breadcrumbContent.innerHtml = '''
            <li class="breadcrumb-item"><a href="#/master/dashboard">Главная</a></li>
            <li class="breadcrumb-item"><a href="#/master/requestList">Список заявок</a></li>
            <li class="breadcrumb-item"><a href="#/master/request">Создание заявки</a></li>
            <li class="breadcrumb-item"><a href="#/master/request/view">Первичная документация</a></li>
            <li class="breadcrumb-item active">Time Sheet</li>
    ''';
  }

  @override
  void ngAfterViewInit() {
    breadcrumbInit();

    document.body.classes.remove('mobile-open');
    document.body.classes.remove('aside-menu-open');

    var table = querySelector('[time-sheet]') as TableElement;

    for (int rowIndex = 0; rowIndex < table.rows.length; ++rowIndex) {
      for (int colIndex = 0; colIndex < table.rows[rowIndex].cells.length; ++colIndex) {
        if (colIndex == 0)
          continue;

        if (colIndex == table.rows[rowIndex].cells.length - 1)
          continue;

        if (rowIndex == 6 || rowIndex == 10)
          continue;

        TableCellElement currentCell = table.rows[rowIndex].cells[colIndex];

        currentCell.onClick.listen(handleLeftClick);
        currentCell.onContextMenu.listen(handleRightClick);
      }
    }
  }

  void handleLeftClick(MouseEvent e) {
    var currentCell = e.currentTarget as TableCellElement;
    double currentValue = double.parse(currentCell.innerHtml, (_) => 0.0);

    currentCell.innerHtml = (currentValue + 1).toString();

    updateTable();
  }

  void handleRightClick(MouseEvent e) {
    e.preventDefault();

    var currentCell = e.currentTarget as TableCellElement;
    double currentValue = double.parse(currentCell.innerHtml, (_) => 0.0);

    if (currentValue == 0)
      currentCell.innerHtml = '';

    if (currentValue <= 0)
      return;

    currentCell.innerHtml = (currentValue - 0.5).toString();

    updateTable();
  }

  void updateTable() {
    var table = querySelector('[time-sheet]') as TableElement;

    for (int colIndex = 1; colIndex < 32; ++colIndex) {
      double colTotal = 0.0;

      for (int rowIndex = 0; rowIndex < 6; ++rowIndex) {
        TableCellElement currentCell = table.rows[rowIndex].cells[colIndex];

        double currentValue = double.parse(currentCell.innerHtml, (_) => 0.0);
        colTotal += currentValue;
      }

      table.rows[6].cells[colIndex].innerHtml = colTotal.toString();
    }

    for (int colIndex = 1; colIndex < 32; ++colIndex) {
      double colTotal = 0.0;

      for (int rowIndex = 7; rowIndex < 10; ++rowIndex) {
        TableCellElement currentCell = table.rows[rowIndex].cells[colIndex];

        double currentValue = double.parse(currentCell.innerHtml, (_) => 0.0);
        colTotal += currentValue;
      }

      table.rows[10].cells[colIndex].innerHtml = colTotal.toString();
    }

    for (int rowIndex = 0; rowIndex < table.rows.length; ++rowIndex) {
      double rowTotal = 0.0;

      for (int colIndex = 0; colIndex < table.rows[rowIndex].cells.length; ++colIndex) {
        if (colIndex == 0)
          continue;

        TableCellElement currentCell = table.rows[rowIndex].cells[colIndex];

        if (colIndex == table.rows[rowIndex].cells.length - 1) {
          currentCell.innerHtml = rowTotal.toString();

          continue;
        }

        double currentValue = double.parse(currentCell.innerHtml, (_) => 0.0);

        rowTotal += currentValue;
      }
    }
  }
}
