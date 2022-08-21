// ignore: file_names
class Pair<T, M> {
  late T first;
  late M second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return first.toString() + second.toString();
  }
}
