import type { SpectatorProjection } from "../types.ts";

const scorpion = {
  nickname: "IVO",
  fighterName: "Scorpion",
  fighterSlug: "scorpion",
};
const subZero = {
  nickname: "MIKA",
  fighterName: "Sub-Zero",
  fighterSlug: "sub-zero",
};
const kitana = {
  nickname: "LENA",
  fighterName: "Kitana",
  fighterSlug: "kitana",
  guest: true,
};
const raiden = {
  nickname: "ROMAN",
  fighterName: "Raiden",
  fighterSlug: "raiden",
  guest: true,
};

export const spectatorFixture: SpectatorProjection = {
  connection: { state: "live", label: "Прямой эфир", sequence: 58 },
  tournament: {
    title: "Friday Fatality",
    format: "Double Elimination",
    progress: "Матч 6 из 9",
  },
  previous: {
    id: "m5",
    stage: "Нижняя сетка",
    label: "Раунд 2",
    first: kitana,
    second: raiden,
    score: [2, 1],
    winnerId: "kitana",
    state: "previous",
  },
  current: {
    id: "m6",
    stage: "Верхняя сетка",
    label: "Финал",
    first: scorpion,
    second: subZero,
    score: [1, 1],
    state: "current",
  },
  next: {
    id: "m7",
    stage: "Нижняя сетка",
    label: "Финал",
    first: kitana,
    second: raiden,
    state: "next",
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
    { place: 1, identity: scorpion, played: 3, wins: 3, points: 8 },
    { place: 2, identity: subZero, played: 3, wins: 2, points: 6 },
    { place: 3, identity: kitana, played: 4, wins: 2, points: 5 },
    { place: 4, identity: raiden, played: 4, wins: 1, points: 3 },
  ],
  champion: scorpion,
};
