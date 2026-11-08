/// Fixed preview data, not application URLs or access tokens.
enum QrPayloadSample {
  shortLink('http://host.local/spectator'),
  longLink(
    'https://example.test/spectator/tournament-with-a-long-session-address?session=48271930615&token=abcdefghijklmnopqrstuvwxyz0123456789',
  ),
  unicodeLink('https://example.test/турнир?имя=Иван');

  const QrPayloadSample(this.data);
  final String data;
}
