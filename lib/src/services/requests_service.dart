import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';
import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import '../view/detailed_request_model.dart';
import '../compose/write_request_model.dart';
import '../list/request_model.dart';
import '../view/request_status.dart';

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

    dynamic json = JSON.decode(response.body);

    var result = new List<RequestModel>();

    for (dynamic request in json) {
      RequestModel model = new RequestModel().fromJson(request);
      result.add(model);
    }

    return result;
  }

  /**
   * Получение одной заявки по ее id
   */
  Future<DetailedRequestModel> getRequest(String id) async {
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

    return new DetailedRequestModel().fromJson(json);
  }

  /**
   * Создание новой заявки
   */
  Future<WriteRequestModel> createRequest(WriteRequestModel model) async {
    Response response = null;

    _logger.trace('Creating request ${ model.toJson() }');

    try {
      response = await _http.post(_config.helper.requestsUrl,
          body: model.toJsonString(),
          headers: {'Content-Type': 'application/json'});

      _logger.trace('Request created');
    } catch (e) {
      print('Failed to compose request: $e');

      throw new Exception('Failed to compose request. Cause: $e');
    }

    dynamic json = JSON.decode(response.body);

    return new WriteRequestModel().fromJson(json);
  }

  /**
   * Изменение данных заявки на проверку
   */
  updateRequest(WriteRequestModel model) async {
    Response response = null;

    _logger.trace('Updating request ${ model.toJson() }');

    try {
      response = await _http.put('${ _config.helper.requestsUrl }/${ model.id }',
          headers: {'Content-Type': 'application/json'},
          body: JSON.encode(model.callOffOrderIds));
      _logger.trace('Request ${ model.id } successfuly updated');
    } catch (e) {
      _logger.error('Failed to update request: $e');

      throw new Exception('Failed to update request. Cause: $e');
    }

    dynamic json = JSON.decode(response.body);

    return new WriteRequestModel().fromJson(json);
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

  /**
   * Обновление статуса заявки
   */
  setStatus(String id, RequestStatus status) async {
    _logger.trace('Change request status. Url: ${ _config.helper.requestsUrl }/$id, Status: ${ status.toString() }');

    try {
      await _http.put('${ _config.helper.requestsUrl }/$id?status=${ status.toString() }',
    headers: {'Content-Type': 'application/json'});
    _logger.trace('Request status changed');
    } catch (e) {
    _logger.error('Failed to update request status: $e');

    throw new Exception('Failed to update request status. Cause: $e');
    }
  }
}