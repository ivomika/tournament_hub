import { useEffect, useMemo, useState } from "react";
import { SpectatorClient } from "./client.ts";
import type { SpectatorClientState } from "./reducer.ts";

export function useSpectatorClient(): {
  state: SpectatorClientState;
  retry: () => void;
} {
  const client = useMemo(() => new SpectatorClient(), []);
  const [state, setState] = useState(client.current);

  useEffect(() => {
    const unsubscribe = client.subscribe(setState);
    client.start();
    return () => {
      unsubscribe();
      client.stop();
    };
  }, [client]);

  return { state, retry: () => client.retry() };
}
