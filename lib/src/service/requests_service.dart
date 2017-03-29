import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';
import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import '../request_model.dart';

/**
 * Работа с web-сервисом. Раздел "Заявки на проверку"
 */
@Injectable()
class RequestsService {
  final Client _http;
  final ConfigService _config;
  LoggerService _logger;
  String _backendUrl = null;
  bool _initialized = false;

  RequestsService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  _init() async {
    String backendScheme = await _config.Get<String>('backend_scheme');
    String backendBaseUrl = await _config.Get<String>('backend_base_url');
    String backendPort = await _config.Get<String>('backend_port');
    String backendRequests = await _config.Get<String>('backend_requests');

    _backendUrl =
        '$backendScheme://$backendBaseUrl:$backendPort/$backendRequests';

    _initialized = true;
  }

  /**
   * Получение списка заявок на проверку
   */
  Future<List<RequestModel>> getRequests() async {
    if (!_initialized) await _init();

    _logger.trace('Getting requests. Url: $_backendUrl');

    Response response = null;

    try {
      response = await _http
          .get(_backendUrl, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get request list: $e');

      throw new Exception('Failed to get request list. Cause: $e');
    }

    _logger.trace('Requests requested: $response.');

    return JSON.decode(response.body);
  }

  /**
   * Получение одной заявки по ее id
   */
  Future<RequestModel> getRequest(String id) async {
    if (!_initialized) await _init();

    Response response = null;

    _logger.trace('Getting request. Url: $_backendUrl/$id');

    try {
      response = await _http.get('$_backendUrl/$id',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get request: $e');

      throw new Exception('Failed to get requet. Cause: $e');
    }

    _logger.trace('Contract requested: $response.');

    dynamic json = JSON.decode(response.body);

    return new RequestModel.fromJson(json);
  }

  /**
   * Создание новой заявки
   */
  Future<String> createRequest(RequestModel model) async {
    if (!_initialized) await _init();

    Response response = null;

    _logger.trace('Creating request ${model.toJsonString()}');

    try {
      response = await _http.post(_backendUrl,
          body: model.toJsonString(),
          headers: {'Content-Type': 'application/json'});

      _logger.trace('Request created');
    } catch (e) {
      print('Failed to create request: $e');

      throw new Exception('Failed to create request. Cause: $e');
    }

    return response.body;
  }

  /**
   * Изменение данных заявки на проверку
   */
  updateContract(RequestModel model) async {
    if (!_initialized) await _init();

    _logger.trace('Updating request ${model.toJsonString()}');

    try {
      await _http.put(_backendUrl,
          headers: {'Content-Type': 'application/json'},
          body: model.toJsonString());
      _logger.trace('Request ${model.id} successfuly updated');
    } catch (e) {
      _logger.error('Failed to update request: $e');

      throw new Exception('Failed to update request. Cause: $e');
    }
  }

  /**
   * Удаление заявки на проверку
   */
  deleteRequest(String id) async {
    if (!_initialized) await _init();

    _logger.trace('Removing request. Url: $_backendUrl/$id');

    try {
      await _http.delete('$_backendUrl/$id',
          headers: {'Content-Type': 'application/json'});
      _logger.trace('Request $id removed');
    } catch (e) {
      _logger.error('Failed to remove request: $e');

      throw new Exception('Failed to remove request. Cause: $e');
    }
  }
}
