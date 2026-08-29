import '../connection_qr_card/connection_qr_card.dart';
import '../spectator_access_dialog/spectator_access_view_data.dart';
import '../status_badge/status_badge.dart';

class HostOpenConnectionViewData {
  const HostOpenConnectionViewData({
    required this.state,
    required this.connectedSpectators,
    required this.statusLabel,
    required this.detail,
    required this.kind,
    this.localEndpoint,
  });

  final ConnectionQrState state;
  final int connectedSpectators;
  final String statusLabel;
  final String detail;
  final StatusKind kind;
  final String? localEndpoint;

  SpectatorAccessViewData get spectatorAccess => SpectatorAccessViewData(
    endpoint: localEndpoint,
    state: state,
    connectedClients: connectedSpectators,
  );
}

const previewHostOpenConnectionViewData = HostOpenConnectionViewData(
  state: ConnectionQrState.ready,
  connectedSpectators: 0,
  statusLabel: 'Зрительский экран доступен',
  detail: '0 подключено · QR открывается по кнопке',
  kind: StatusKind.success,
  localEndpoint: 'http://192.168.1.42:8080',
);
