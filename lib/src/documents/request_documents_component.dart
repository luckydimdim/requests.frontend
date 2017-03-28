import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'documents',
    templateUrl: 'request_documents_component.html',
    directives: const [RouterLink])
class RequestDocumentsComponent implements OnInit, AfterViewInit {
  static const DisplayName = const { 'displayName': 'Документация' };
  static const String route_name = 'Documents';
  static const String route_path = 'documents';
  static const Route route = const Route(
      path: RequestDocumentsComponent.route_path,
      component: RequestDocumentsComponent,
      name: RequestDocumentsComponent.route_name);

  final Router _router;
  final RouteParams _routeParams;

  RequestDocumentsComponent(this._router, this._routeParams) {}

  @override
  void ngOnInit() {
    breadcrumbInit();
  }

  void breadcrumbInit(){
    var  breadcrumbContent = querySelector('#breadcrumbContent') as HtmlElement;

    if (breadcrumbContent == null)
      return;

    breadcrumbContent.innerHtml = '''
            <li class="breadcrumb-item"><a href="#/master/dashboard">Главная</a></li>
            <li class="breadcrumb-item"><a href="#/master/requestList">Список заявок</a></li>
            <li class="breadcrumb-item"><a href="#/master/request">Создание заявки</a></li>            
            <li class="breadcrumb-item active">Первичная документация</li>
    ''';
  }

  @override
  void ngAfterViewInit() {
    // FIXME: скрол не работает
    window.scrollTo(0, 0);

    var button = querySelector('[btn-aprove]') as ButtonElement;
    button.onClick.listen((MouseEvent e) {
      _router.navigate(['RequestList']);
    });

    sticky();
  }

  /**
   * Фиксация боковой панели
   */
  void sticky() {
    var width = querySelector('[sticky]').getComputedStyle().width;

    // При ресайзе окна ширина панели
    // подстраивается под ширину родительского элемента
    window.onResize.listen((Event e) {
      width = querySelector('[sticky]').parent.clientWidth;

      var paddingLeft = querySelector('[sticky]').parent.getComputedStyle().paddingLeft.replaceAll('px', '');
      var paddingRight = querySelector('[sticky]').parent.getComputedStyle().paddingRight.replaceAll('px', '');

      var pl = int.parse(paddingLeft);
      var pr = int.parse(paddingRight);

      width = width - pl - pr;

      querySelector('[sticky]').style.width = width.toString() + 'px';
    });

    // При прокрутке окна устанавливается position: fixed
    window.onScroll.listen((Event e) {
      var div = querySelector('[sticky]') as DivElement;
      if (window.pageYOffset > 0) {
        div.style.position = 'fixed';
        div.style.width = width;
      } else {
        div.style.position = 'relative';
      }
    });
  }
}