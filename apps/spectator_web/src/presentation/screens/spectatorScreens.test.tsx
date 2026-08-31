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

  it("показывает completed, current и upcoming lanes в одном read order", () => {
    render(<DashboardScreen projection={spectatorFixture} />);

    const completed = screen.getByRole("region", { name: "Завершённые" });
    const current = screen.getByRole("region", { name: "Сейчас" });
    const upcoming = screen.getByRole("region", { name: "Будущие" });
    expect(
      completed.compareDocumentPosition(current) &
        Node.DOCUMENT_POSITION_FOLLOWING,
    ).toBeTruthy();
    expect(
      current.compareDocumentPosition(upcoming) &
        Node.DOCUMENT_POSITION_FOLLOWING,
    ).toBeTruthy();
    expect(
      screen.getByLabelText(/Завершён: Kitana, LENA против Raiden, ROMAN. 2:1/),
    ).toBeInTheDocument();
    expect(
      screen.getByLabelText(
        /Следующий: Kitana, LENA против Raiden, ROMAN. Счёт ещё не определён/,
      ),
    ).toBeInTheDocument();
  });

  it("completed card не подставляет ложный ноль и сохраняет длинные identity", () => {
    const completed = {
      ...spectatorFixture.timeline.completed[0]!,
      first: {
        ...spectatorFixture.timeline.completed[0]!.first,
        fighterName: "Rambo с очень длинным именем бойца",
        nickname: "Очень длинное имя участника",
      },
      second: {
        ...spectatorFixture.timeline.completed[0]!.second,
        fighterName: "Scarlet с очень длинным именем бойца",
        nickname: "Ещё одно длинное имя гостя",
      },
      score: undefined,
      resultLabel: "Техническая победа",
    };
    render(
      <DashboardScreen
        projection={{
          ...spectatorFixture,
          timeline: {
            ...spectatorFixture.timeline,
            completed: [completed],
          },
        }}
      />,
    );

    expect(
      screen.getByText("Rambo с очень длинным именем бойца"),
    ).toBeInTheDocument();
    expect(
      screen.getByText("Scarlet с очень длинным именем бойца"),
    ).toBeInTheDocument();
    expect(screen.getByText("Техническая победа")).toBeInTheDocument();
    expect(screen.queryByText("0")).not.toBeInTheDocument();
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
