import type { SpectatorProjection } from "../types.ts";

const scorpion = {
  participantId: "participant-1",
  nickname: "IVO",
  fighterName: "Scorpion",
  fighterAssetPath: "/fighters/scorpion.png",
};
const subZero = {
  participantId: "participant-2",
  nickname: "MIKA",
  fighterName: "Sub-Zero",
  fighterAssetPath: "/fighters/sub-zero.png",
};
const kitana = {
  participantId: "participant-3",
  nickname: "LENA",
  fighterName: "Kitana",
  fighterAssetPath: "/fighters/kitana.png",
  guest: true,
};
const raiden = {
  participantId: "participant-4",
  nickname: "ROMAN",
  fighterName: "Raiden",
  fighterAssetPath: "/fighters/raiden.png",
  guest: true,
};

export const spectatorFixture: SpectatorProjection = {
  connection: { state: "live", label: "Прямой эфир", sequence: 58 },
  tournament: {
    title: "Friday Fatality",
    format: "Double Elimination",
    progress: "Матч 6 из 9",
    lifecycle: "running",
  },
  participants: [scorpion, subZero, kitana, raiden],
  timeline: {
    completed: [
      {
        id: "m5",
        stage: "Нижняя сетка",
        label: "Раунд 2",
        first: kitana,
        second: raiden,
        score: [2, 1],
        winnerId: "kitana",
        state: "previous",
      },
    ],
    current: {
      id: "m6",
      stage: "Верхняя сетка",
      label: "Финал",
      first: scorpion,
      second: subZero,
      score: [1, 1],
      state: "current",
    },
    upcoming: [
      {
        id: "m7",
        stage: "Нижняя сетка",
        label: "Финал",
        first: kitana,
        second: raiden,
        state: "next",
      },
    ],
  },
  bracket: [
    {
      id: "m1",
      stage: "Верхняя сетка",
      label: "Полуфинал",
      first: scorpion,
      second: kitana,
      score: [2, 0],
      winnerId: "scorpion",
      state: "previous",
    },
    {
      id: "m2",
      stage: "Верхняя сетка",
      label: "Полуфинал",
      first: subZero,
      second: raiden,
      score: [2, 1],
      winnerId: "sub-zero",
      state: "previous",
    },
    {
      id: "m6",
      stage: "Верхняя сетка",
      label: "Финал",
      first: scorpion,
      second: subZero,
      score: [1, 1],
      state: "current",
    },
    {
      id: "m5",
      stage: "Нижняя сетка",
      label: "Раунд 2",
      first: kitana,
      second: raiden,
      score: [2, 1],
      winnerId: "kitana",
      state: "previous",
    },
    {
      id: "m7",
      stage: "Нижняя сетка",
      label: "Финал",
      first: kitana,
      second: raiden,
      state: "next",
    },
  ],
  standings: [
    { participantId: "participant-1", placeLabel: "1", identity: scorpion },
    { participantId: "participant-2", placeLabel: "2", identity: subZero },
    { participantId: "participant-3", placeLabel: "3", identity: kitana },
    { participantId: "participant-4", placeLabel: "4", identity: raiden },
  ],
  champion: scorpion,
};
