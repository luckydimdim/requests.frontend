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

  RequestsService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  /**
   * Получение списка заявок на проверку
   */
  Future<List<RequestModel>> getRequests() async {
    _logger.trace('Getting requests. Url: ${ _config.helper.requestsUrl }');

    Response response = null;

    try {
      response = await _http.get(
        _config.helper.requestsUrl,
        headers: {'Content-Type': 'application/json'});
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
    Response response = null;

    _logger.trace('Getting request. Url: ${ _config.helper.requestsUrl }/$id');

    try {
      response = await _http.get('${ _config.helper.requestsUrl }/$id',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get request: $e');

      throw new Exception('Failed to get requet. Cause: $e');
    }

    _logger.trace('Contract requested: $response.');

    dynamic json = JSON.decode(response.body);

    return new RequestModel().fromJson(json);
  }

  /**
   * Создание новой заявки
   */
  Future<String> createRequest(RequestModel model) async {
    Response response = null;

    _logger.trace('Creating request ${model.toJson()}');

    try {
      response = await _http.post(_config.helper.requestsUrl,
          body: model.toJson(),
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
    _logger.trace('Updating request ${model.toJson()}');

    try {
      await _http.put(_config.helper.requestsUrl,
          headers: {'Content-Type': 'application/json'},
          body: model.toJson());
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
    _logger.trace('Removing request. Url: ${ _config.helper.requestsUrl }/$id');

    try {
      await _http.delete('${ _config.helper.requestsUrl }/$id',
          headers: {'Content-Type': 'application/json'});
      _logger.trace('Request $id removed');
    } catch (e) {
      _logger.error('Failed to remove request: $e');

      throw new Exception('Failed to remove request. Cause: $e');
    }
  }
}