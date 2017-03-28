import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:resources_loader/resources_loader.dart';

@Component(
    selector: 'request-creator',
    templateUrl: 'request_creator_component.html',
    directives: const [RouterLink])
class RequestCreatorComponent implements OnInit {
  static const DisplayName = const { 'displayName': 'Формирование заявки' };
  final ResourcesLoaderService _resourcesLoaderService;

  RequestCreatorComponent(this._resourcesLoaderService) {}

  void breadcrumbInit(){

  }

  @override
  void ngOnInit() {
    breadcrumbInit();

    return;

    // TODO: Продумать показ/скрытие меню
    document.body.classes.add('mobile-open');
    document.body.classes.add('aside-menu-open');

    // TODO: Сделать более удобным переключение вкладок и показ/скрытие меню
    var oldActiveLink =
    querySelector('.aside-menu .nav-tabs li a.active') as AnchorElement;
    oldActiveLink.classes.remove('active');

    var newActiveLink =
    querySelector('.aside-menu .nav-tabs li a[href="#creator"]')
    as AnchorElement;
    newActiveLink.classes.add('active');

    var oldActivePanel =
    querySelector('.aside-menu .tab-content div.active') as DivElement;
    oldActivePanel.classes.remove('active');

    var newActivePanel =
    querySelector('.aside-menu .tab-content div[id="creator"]')
    as DivElement;
    newActivePanel.classes.add('active');

    // TODO: Продумать управления содержимым бокового меню
    var htmlElement = '''
    <h6>Создание заявки на проверку</h6>
      <div>
      <small class="text-muted">Выберите договор и укажите период для
      отображения списка работ и материалов.
      </small>
      </div>
      <div class="aside-options">
      <div class="clearfix mt-2">
      <form action="" method="post" class="ng-pristine ng-valid">
      <div class="form-group">
      <div class="input-group">
      <span class="input-group-addon"><i class="fa fa-file"></i>
      </span>
      <input type="text" id="contract-number"
      name="contract-number" class="form-control"
      placeholder="Договор"/>
      </div>
      </div>
      <div class="form-group form-actions">
      <button type="submit" class="btn btn-sm btn-success">
      Показать работы и материалы
      </button>
      </div>
      </form>
      </div>
      </div>
      <hr/>''';

    newActivePanel.innerHtml = htmlElement;
  }

  void render(dynamic e) {
  }

}