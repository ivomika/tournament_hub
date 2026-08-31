import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import type { MatchModel } from "../../types.ts";
import { spectatorFixture } from "../../fixtures/spectatorFixture.ts";
import { BracketView } from "./BracketView.tsx";
import { buildBracketLanes } from "./bracketModel.ts";

const baseMatch = spectatorFixture.bracket[0]!;

describe("BracketView", () => {
  it("разделяет канонические DE lanes, Grand Final и Reset", () => {
    const lanes = buildBracketLanes(
      "double-elimination",
      spectatorFixture.bracket,
    );
    expect(lanes.map((lane) => lane.kind)).toEqual([
      "winners",
      "losers",
      "finals",
    ]);
    expect(
      lanes[2]?.rounds.flatMap((round) =>
        round.matches.map((match) => match.stageId),
      ),
    ).toEqual(["finalMatch", "bracketReset"]);
  });

  it("использует отдельные SE и RR compositions", () => {
    const matches = [
      { ...baseMatch, id: "one", stageId: "main", round: 1 },
      { ...baseMatch, id: "two", stageId: "main", round: 2 },
    ];
    expect(buildBracketLanes("single-elimination", matches)).toMatchObject([
      { kind: "main", label: "Раунды Single Elimination" },
    ]);
    expect(buildBracketLanes("round-robin", matches)).toMatchObject([
      { kind: "round-robin", label: "Раунды Round Robin" },
    ]);
  });

  it("управляется кнопками и клавиатурой и сохраняет exit affordance", async () => {
    render(
      <BracketView
        formatId="double-elimination"
        matches={spectatorFixture.bracket}
      />,
    );
    fireEvent.click(screen.getByRole("button", { name: "Увеличить" }));
    expect(screen.getByText("125%")).toBeInTheDocument();

    const canvas = screen.getByLabelText(/Полотно сетки/);
    fireEvent.keyDown(canvas, { key: "+" });
    expect(screen.getByText("150%")).toBeInTheDocument();
    fireEvent.wheel(canvas, { deltaY: 1 });
    expect(screen.getByText("125%")).toBeInTheDocument();
    Object.defineProperty(canvas, "setPointerCapture", {
      configurable: true,
      value: vi.fn(),
    });
    Object.defineProperty(canvas, "releasePointerCapture", {
      configurable: true,
      value: vi.fn(),
    });
    fireEvent.pointerDown(canvas, {
      pointerId: 7,
      pointerType: "touch",
      clientX: 10,
      clientY: 10,
    });
    fireEvent.pointerMove(canvas, {
      pointerId: 7,
      pointerType: "touch",
      clientX: 40,
      clientY: 50,
    });
    expect(
      document.querySelector<HTMLElement>(".bracket-canvas")?.style.transform,
    ).toContain("translate(30px, 40px)");
    fireEvent.pointerUp(canvas, { pointerId: 7, pointerType: "touch" });
    fireEvent.keyDown(canvas, { key: "ArrowRight" });
    fireEvent.click(screen.getByRole("button", { name: "Сбросить" }));
    expect(screen.getByText("100%")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Вписать" }));

    const viewport = screen.getByLabelText("Структура турнира");
    const requestFullscreen = vi.fn(async () => {
      Object.defineProperty(document, "fullscreenElement", {
        configurable: true,
        value: viewport,
      });
      document.dispatchEvent(new Event("fullscreenchange"));
    });
    Object.defineProperty(viewport, "requestFullscreen", {
      configurable: true,
      value: requestFullscreen,
    });
    fireEvent.click(screen.getByRole("button", { name: "На весь экран" }));
    expect(requestFullscreen).toHaveBeenCalledOnce();
    expect(
      await screen.findByRole("button", {
        name: "Выйти из полноэкранного режима",
      }),
    ).toBeInTheDocument();
  });

  it("рендерит fixture из 500 узлов в установленный budget", () => {
    const matches: MatchModel[] = Array.from({ length: 500 }, (_, index) => ({
      ...baseMatch,
      id: `match-${index}`,
      round: Math.floor(index / 20) + 1,
      order: index % 20,
      stageId: "roundRobin",
    }));
    const startedAt = performance.now();
    render(<BracketView formatId="round-robin" matches={matches} />);
    const elapsed = performance.now() - startedAt;

    expect(document.querySelectorAll(".bracket-match")).toHaveLength(500);
    expect(elapsed).toBeLessThan(2500);
  });
});
