import "@testing-library/jest-dom/vitest";
import { cleanup, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it } from "vitest";

import { App } from "./App";
import { decodeSpectatorEnvelope } from "../transport/spectatorProtocol";
import doubleEliminationFixture from "../../../../docs/protocol/fixtures/spectator-double-elimination-active-v1.json";
import roundRobinFixture from "../../../../docs/protocol/fixtures/spectator-round-robin-active-v1.json";

afterEach(cleanup);

describe("Приложение", () => {
  it("показывает состояние ожидания подключения", () => {
    render(
      <App
        state={{
          status: "connecting",
          envelope: null,
          message: null,
          retry: () => undefined,
        }}
      />,
    );

    expect(
      screen.getByRole("heading", { name: "Tournament HUB" }),
    ).toBeVisible();
    expect(screen.getByText(/ожидание состояния турнира/i)).toBeVisible();
  });

  it("показывает dashboard Round Robin из snapshot", () => {
    render(
      <App
        state={{
          status: "connected",
          envelope: decodeSpectatorEnvelope(roundRobinFixture),
          message: null,
          retry: () => undefined,
        }}
      />,
    );

    expect(
      screen.getByRole("heading", { name: "Тестовый Round Robin" }),
    ).toBeVisible();
    expect(screen.getByText("Участники и бойцы")).toBeVisible();
    expect(screen.getByText("Текущие места")).toBeVisible();
    expect(screen.getByText("Раунды и матчи")).toBeVisible();
    expect(screen.getAllByText("Scorpion").length).toBeGreaterThan(0);
  });

  it("показывает каноничную сетку Double Elimination", () => {
    renderConnected(doubleEliminationFixture);

    expect(
      screen.getByRole("heading", { name: "Double Elimination" }),
    ).toBeVisible();
    expect(screen.getByText(/Winners bracket/i)).toBeVisible();
    expect(screen.getByText(/Losers bracket/i)).toBeVisible();
    expect(
      screen.getByRole("button", { name: /увеличить масштаб/i }),
    ).toBeVisible();
  });

  it("сразу открывает финал Round Robin из finished snapshot", () => {
    renderConnected(finishedSnapshot(roundRobinFixture));

    expect(screen.getByText("ТУРНИР ЗАВЕРШЁН")).toBeVisible();
    expect(screen.getByText("ЧЕМПИОН")).toBeVisible();
    expect(screen.getByRole("heading", { name: "Игрок 1" })).toBeVisible();
    expect(screen.getByText("Места участников")).toBeVisible();
    expect(screen.getAllByText("Scorpion").length).toBeGreaterThan(0);
    expect(screen.getByText("Текущие места")).toBeVisible();
  });

  it("показывает финал Double Elimination с завершённой сеткой", () => {
    renderConnected(finishedSnapshot(doubleEliminationFixture));

    expect(screen.getByText("ЧЕМПИОН")).toBeVisible();
    expect(screen.getByText("Места участников")).toBeVisible();
    expect(
      screen.getByRole("heading", { name: "Double Elimination" }),
    ).toBeVisible();
    expect(screen.getAllByText("Sub-Zero").length).toBeGreaterThan(0);
  });
});

function renderConnected(value: unknown) {
  render(
    <App
      state={{
        status: "connected",
        envelope: decodeSpectatorEnvelope(value),
        message: null,
        retry: () => undefined,
      }}
    />,
  );
}

function finishedSnapshot(value: unknown) {
  const snapshot = structuredClone(value) as {
    payload: {
      state: string;
      championId: string | null;
      placements: string[];
    };
  };
  snapshot.payload.state = "finished";
  snapshot.payload.championId = "player-1";
  snapshot.payload.placements = ["player-1", "player-2"];
  return snapshot;
}
