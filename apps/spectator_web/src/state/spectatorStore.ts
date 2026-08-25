import type { SpectatorEnvelope } from "../transport/spectatorProtocol";

export class SpectatorStore {
  private currentEnvelope: SpectatorEnvelope | null = null;

  get snapshot(): SpectatorEnvelope | null {
    return this.currentEnvelope;
  }

  apply(envelope: SpectatorEnvelope): boolean {
    const current = this.currentEnvelope;
    if (
      current?.tournamentId === envelope.tournamentId &&
      envelope.revision <= current.revision
    ) {
      return false;
    }
    this.currentEnvelope = envelope;
    return true;
  }

  clear(): void {
    this.currentEnvelope = null;
  }
}
