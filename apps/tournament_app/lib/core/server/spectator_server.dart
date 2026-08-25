abstract interface class SpectatorServer {
  int get clientCount;
  Stream<int> get clientCountChanges;

  Future<Uri> start();
  Future<void> publish(String message);
  Future<void> stop();
}
