export type SpectatorView = "dashboard" | "tournament" | "champion";

export type ConnectionState = "live" | "stale" | "reconnecting" | "connecting";

export interface FighterIdentityModel {
  nickname: string;
  fighterName: string;
  fighterSlug: string;
  guest?: boolean;
}

export interface MatchModel {
  id: string;
  stage: string;
  label: string;
  first: FighterIdentityModel;
  second: FighterIdentityModel;
  score?: readonly [number, number];
  winnerId?: string;
  state: "previous" | "current" | "next";
}

export interface StandingModel {
  place: number;
  identity: FighterIdentityModel;
  played: number;
  wins: number;
  points: number;
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
  };
  previous: MatchModel;
  current: MatchModel;
  next: MatchModel;
  bracket: readonly MatchModel[];
  standings: readonly StandingModel[];
  champion: FighterIdentityModel;
}
