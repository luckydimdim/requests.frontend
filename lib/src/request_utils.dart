class RequestUtils {
/**
 * Подставляет нужный css класс в столбце со статусами
 */
  static Map<String, bool> resolveStatusStyleClass(String statusSysName) {
    Map<String, bool> result = new Map<String, bool>();

    if (statusSysName == null) return result;

    String status = statusSysName.toUpperCase();

    switch (status) {
      case 'EMPTY':
        result['tag-default'] = true;
        break;
      case 'CREATED':
      case 'CORRECTED':
        result['tag-primary'] = true;
        break;
      case 'APPROVING':
        result['tag-warning'] = true;
        break;
      case 'APPROVED':
        result['tag-success'] = true;
        break;
      case 'CORRECTING':
        result['tag-danger'] = true;
        break;
      default:
        result['tag-info'] = true;
    }

    return result;
  }
}
