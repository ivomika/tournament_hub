import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { toPresentationProjection } from "../../application/spectator/presentationMapper.ts";
import { projectionFixture } from "../../application/spectator/testFixture.ts";
import { ConnectionStatePanel } from "../components/connection-state-panel/ConnectionStatePanel.tsx";
import { spectatorFixture } from "../fixtures/spectatorFixture.ts";
import { ChampionScreen } from "./ChampionScreen.tsx";
import { DashboardScreen } from "./DashboardScreen.tsx";
import { TournamentScreen } from "./TournamentScreen.tsx";

describe("Spectator screens", () => {
  it("показывает waiting/incompatible текстом", () => {
    const { rerender } = render(<ConnectionStatePanel state="waiting" />);
    expect(screen.getByText("Ожидаем начало турнира")).toBeInTheDocument();
    rerender(<ConnectionStatePanel state="incompatible" />);
    expect(screen.getByText("Версия экрана несовместима")).toBeInTheDocument();
  });

  it("показывает fighter identity текущего матча без mutation controls", () => {
    const projection = toPresentationProjection({
      connection: "live",
      projection: projectionFixture,
      lastSequence: 7,
    })!;
    render(<DashboardScreen projection={projection} />);
    expect(screen.getByLabelText(/Текущий матч/)).toBeInTheDocument();
    expect(screen.getByLabelText(/Scorpion, Иван/)).toBeInTheDocument();
    expect(screen.queryByRole("button")).not.toBeInTheDocument();
  });

  it("показывает structure/standings и champion", () => {
    const { rerender } = render(
      <TournamentScreen projection={spectatorFixture} />,
    );
    expect(screen.getByLabelText("Структура турнира")).toBeInTheDocument();
    rerender(
      <ChampionScreen
        projection={{
          ...spectatorFixture,
          tournament: { ...spectatorFixture.tournament, lifecycle: "finished" },
        }}
      />,
    );
    expect(
      screen.getByRole("heading", { name: "Чемпион" }),
    ).toBeInTheDocument();
    expect(screen.getAllByLabelText(/Scorpion, IVO/)).not.toHaveLength(0);
  });
});
