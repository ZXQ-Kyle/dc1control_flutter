class HttpResult<T> {
  bool success;
  T data;
  String message;

  HttpResult.fail({this.message}) : success = false;

  HttpResult.success({this.data}) : success = true;
}
