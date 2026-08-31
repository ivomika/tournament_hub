import type { SpectatorProjectionDto } from "./protocol.ts";

export const projectionFixture: SpectatorProjectionDto = {
  tournamentId: "t-1",
  revision: 7,
  sequence: 7,
  snapshotVersion: 1,
  tournament: {
    title: "Friday Fight",
    formatId: "single-elimination",
    rulesetVersion: 1,
    lifecycle: "running",
  },
  participants: [
    {
      participantId: "participant-1",
      nickname: "Иван",
      isGuest: false,
      fighter: {
        fighterId: "scorpion",
        displayName: "Scorpion",
        assetPath: "assets/fighters/scorpion.png",
      },
    },
    {
      participantId: "participant-2",
      nickname: "Гость",
      isGuest: true,
      fighter: {
        fighterId: "sub-zero",
        displayName: "Sub-Zero",
        assetPath: "assets/fighters/sub-zero.png",
      },
    },
  ],
  matches: [
    {
      matchId: "m-1",
      round: 1,
      order: 0,
      stage: "main",
      firstTo: 1,
      firstParticipantId: "participant-1",
      secondParticipantId: "participant-2",
      status: "current",
    },
  ],
  standings: [],
};
