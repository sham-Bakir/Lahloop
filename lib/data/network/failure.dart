class Failure {
  int code; // 200, 201, 303, 400, 500, etc...
  String message;
  Failure(this.code, this.message);
}
