import type { SpectatorConnectionState } from "../application/spectator/reducer.ts";

export type SpectatorView = "dashboard" | "tournament" | "champion";
export type ConnectionState = SpectatorConnectionState;

export interface FighterIdentityModel {
  participantId: string;
  nickname: string;
  fighterName: string;
  fighterAssetPath?: string;
  guest?: boolean;
}

export interface MatchModel {
  id: string;
  stage: string;
  label: string;
  first: FighterIdentityModel;
  second: FighterIdentityModel;
  score?: readonly [number, number];
  resultLabel?: string;
  winnerId?: string;
  state: "previous" | "current" | "next";
}

export interface StandingModel {
  participantId: string;
  placeLabel: string;
  identity: FighterIdentityModel;
}

export interface SpectatorProjection {
  connection: {
    state: ConnectionState;
    label: string;
    sequence: number;
  };
  tournament: {
    title: string;
    format: string;
    progress: string;
    lifecycle: "distribution" | "running" | "finished";
  };
  participants: readonly FighterIdentityModel[];
  previous?: MatchModel;
  current?: MatchModel;
  next?: MatchModel;
  bracket: readonly MatchModel[];
  standings: readonly StandingModel[];
  champion?: FighterIdentityModel;
}
