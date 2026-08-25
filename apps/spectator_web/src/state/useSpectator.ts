import { useCallback, useEffect, useRef, useState } from "react";

import {
  currentSpectatorWebSocketUrl,
  SpectatorTransport,
  type ConnectionStatus,
} from "../transport/spectatorTransport";
import type { SpectatorEnvelope } from "../transport/spectatorProtocol";
import { SpectatorStore } from "./spectatorStore";

export interface SpectatorViewState {
  status: ConnectionStatus;
  envelope: SpectatorEnvelope | null;
  message: string | null;
  retry: () => void;
}

export function useSpectator(): SpectatorViewState {
  const [status, setStatus] = useState<ConnectionStatus>("connecting");
  const [message, setMessage] = useState<string | null>(null);
  const [envelope, setEnvelope] = useState<SpectatorEnvelope | null>(null);
  const transportRef = useRef<SpectatorTransport | null>(null);

  useEffect(() => {
    const store = new SpectatorStore();
    const transport = new SpectatorTransport({
      url: currentSpectatorWebSocketUrl(),
      onEnvelope: (next) => {
        if (store.apply(next)) setEnvelope(store.snapshot);
      },
      onStatus: (nextStatus, nextMessage) => {
        setStatus(nextStatus);
        setMessage(nextMessage ?? null);
      },
    });
    transportRef.current = transport;
    transport.start();
    return () => {
      transportRef.current = null;
      transport.stop();
    };
  }, []);

  const retry = useCallback(() => transportRef.current?.retry(), []);
  return { status, envelope, message, retry };
}
