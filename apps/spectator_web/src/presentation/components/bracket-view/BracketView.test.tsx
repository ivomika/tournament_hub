import { readFileSync } from "node:fs";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import type { MatchModel } from "../../types.ts";
import { spectatorFixture } from "../../fixtures/spectatorFixture.ts";
import { BracketView } from "./BracketView.tsx";
import { buildBracketLanes } from "./bracketModel.ts";

const baseMatch = spectatorFixture.bracket[0]!;
const themeCss = readFileSync(
  "src/presentation/design-system/theme.css",
  "utf8",
);
const tokensCss = readFileSync(
  "src/presentation/design-system/tokens.css",
  "utf8",
);

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

    const panArea = screen.getByLabelText(/Полотно сетки/);
    fireEvent.keyDown(panArea, { key: "+" });
    expect(screen.getByText("150%")).toBeInTheDocument();
    fireEvent.wheel(panArea, { deltaY: 1 });
    expect(screen.getByText("125%")).toBeInTheDocument();
    Object.defineProperty(panArea, "setPointerCapture", {
      configurable: true,
      value: vi.fn(),
    });
    Object.defineProperty(panArea, "releasePointerCapture", {
      configurable: true,
      value: vi.fn(),
    });
    fireEvent.pointerDown(panArea, {
      pointerId: 7,
      pointerType: "touch",
      clientX: 10,
      clientY: 10,
    });
    fireEvent.pointerMove(panArea, {
      pointerId: 7,
      pointerType: "touch",
      clientX: 40,
      clientY: 50,
    });
    expect(
      document.querySelector<HTMLElement>(".bracket-canvas")?.style.transform,
    ).toContain("translate(30px, 40px)");
    fireEvent.pointerUp(panArea, { pointerId: 7, pointerType: "touch" });
    fireEvent.keyDown(panArea, { key: "ArrowRight" });
    fireEvent.click(screen.getByRole("button", { name: "Сбросить" }));
    expect(screen.getByText("100%")).toBeInTheDocument();
    const bracketCanvas =
      document.querySelector<HTMLElement>(".bracket-canvas")!;
    Object.defineProperties(panArea, {
      clientWidth: { configurable: true, value: 800 },
      clientHeight: { configurable: true, value: 600 },
    });
    Object.defineProperties(bracketCanvas, {
      scrollWidth: { configurable: true, value: 1600 },
      scrollHeight: { configurable: true, value: 1200 },
    });
    fireEvent.click(screen.getByRole("button", { name: "Вписать" }));
    expect(screen.getByText("50%")).toBeInTheDocument();

    const viewport = screen.getByLabelText("Структура турнира");
    const animationFrame = vi
      .spyOn(window, "requestAnimationFrame")
      .mockImplementation((callback) => {
        callback(0);
        return 1;
      });
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
    expect(screen.getByText("50%")).toBeInTheDocument();
    animationFrame.mockRestore();
  });

  it("группирует матчи в каноничные branches с tokenized connectors", () => {
    const { rerender } = render(
      <BracketView
        formatId="double-elimination"
        matches={spectatorFixture.bracket}
      />,
    );

    expect(document.querySelectorAll(".bracket-pair").length).toBeGreaterThan(
      0,
    );
    expect(document.querySelector(".bracket-lane--connected")).not.toBeNull();
    expect(themeCss).toMatch(
      /\.bracket-round:not\(:last-child\)[\s\S]*\.bracket-pair::after/,
    );
    expect(themeCss).toMatch(/\.bracket-match\s*\{[^}]*overflow:\s*visible;/);
    expect(themeCss).toMatch(
      /\.bracket-viewport:fullscreen \.bracket-pan-area\s*\{[^}]*flex:\s*1;/,
    );
    expect(tokensCss).toContain("--ds-border-emphasis:");
    expect(themeCss).toMatch(
      /@media \(min-width: 1280px\)[\s\S]*--bracket-connector-width:\s*var\(--ds-border-emphasis\)/,
    );

    rerender(
      <BracketView formatId="round-robin" matches={spectatorFixture.bracket} />,
    );
    expect(document.querySelector(".bracket-lane--connected")).toBeNull();
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
