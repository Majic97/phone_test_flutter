class EmptyHttpBodyException implements Exception {
  final String object;

  EmptyHttpBodyException(this.object);

  String toString() {
    return "Exception: http body doesn't have any data for $object";
  }
}

class ServerDoesnotAvalibleNow implements Exception {
  String toString() {
    return "Exception: server doesn't avalible now";
  }
}


