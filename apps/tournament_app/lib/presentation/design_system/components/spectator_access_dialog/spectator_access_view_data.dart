import '../connection_qr_card/connection_qr_card.dart';

class SpectatorAccessViewData {
  const SpectatorAccessViewData({
    required this.endpoint,
    required this.state,
    required this.connectedClients,
  });

  final String endpoint;
  final ConnectionQrState state;
  final int connectedClients;
}
