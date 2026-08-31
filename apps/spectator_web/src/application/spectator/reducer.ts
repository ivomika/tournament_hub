import type {
  ProjectionReplacedEvent,
  SpectatorProjectionDto,
} from "./protocol.ts";

export type SpectatorConnectionState =
  | "waiting"
  | "connecting"
  | "synchronizing"
  | "live"
  | "stale"
  | "reconnecting"
  | "incompatible"
  | "error";

export interface SpectatorClientState {
  connection: SpectatorConnectionState;
  projection?: SpectatorProjectionDto;
  lastSequence: number;
  errorCode?: string;
}

export type SpectatorClientAction =
  | { type: "connection"; connection: SpectatorConnectionState }
  | { type: "snapshot"; projection: SpectatorProjectionDto }
  | { type: "event"; event: ProjectionReplacedEvent }
  | { type: "failure"; code: string; incompatible?: boolean };

export const initialSpectatorState: SpectatorClientState = {
  connection: "waiting",
  lastSequence: 0,
};

export function spectatorReducer(
  state: SpectatorClientState,
  action: SpectatorClientAction,
): SpectatorClientState {
  switch (action.type) {
    case "connection":
      return { ...state, connection: action.connection, errorCode: undefined };
    case "snapshot":
      return {
        connection:
          action.projection.tournament.lifecycle === "finished"
            ? "live"
            : "synchronizing",
        projection: action.projection,
        lastSequence: action.projection.sequence,
      };
    case "event": {
      const event = action.event;
      if (event.tournamentId !== state.projection?.tournamentId) {
        return {
          ...state,
          connection: "stale",
          errorCode: "TOURNAMENT_MISMATCH",
        };
      }
      if (event.sequence <= state.lastSequence) return state;
      if (
        event.sequence !== state.lastSequence + 1 ||
        event.payload.projection.sequence !== event.sequence
      ) {
        return { ...state, connection: "stale", errorCode: "SEQUENCE_GAP" };
      }
      return {
        connection: "live",
        projection: event.payload.projection,
        lastSequence: event.sequence,
      };
    }
    case "failure":
      return {
        ...state,
        connection: action.incompatible ? "incompatible" : "error",
        errorCode: action.code,
      };
  }
}
