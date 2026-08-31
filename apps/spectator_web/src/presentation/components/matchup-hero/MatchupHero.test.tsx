import { readFileSync } from "node:fs";
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { spectatorFixture } from "../../fixtures/spectatorFixture.ts";
import { MatchupHero } from "./MatchupHero.tsx";

const themeCss = readFileSync(
  "src/presentation/design-system/theme.css",
  "utf8",
);

describe("MatchupHero", () => {
  it("сохраняет обе matchup identity вертикальными при reverse", () => {
    render(<MatchupHero match={spectatorFixture.timeline.current!} />);

    const identities = screen
      .getByLabelText(/Текущий матч/)
      .querySelectorAll<HTMLElement>(".identity--matchup");

    expect(identities).toHaveLength(2);
    expect(identities[0]).toHaveClass("identity--vertical");
    expect(identities[1]).toHaveClass(
      "identity--vertical",
      "identity--reverse",
    );
    expect(themeCss).toMatch(
      /\.identity--vertical\.identity--reverse\s*\{[^}]*flex-direction:\s*column;/,
    );
  });

  it("сохраняет длинные fighter и participant names внутри identities", () => {
    const current = spectatorFixture.timeline.current!;
    render(
      <MatchupHero
        match={{
          ...current,
          first: {
            ...current.first,
            fighterName: "Frost с очень длинным именем бойца",
            nickname: "Первый участник с очень длинным именем",
          },
          second: {
            ...current.second,
            fighterName: "Mileena с очень длинным именем бойца",
            nickname: "Второй участник с очень длинным именем",
          },
        }}
      />,
    );

    expect(
      screen.getByText("Frost с очень длинным именем бойца"),
    ).toBeInTheDocument();
    expect(
      screen.getByText("Mileena с очень длинным именем бойца"),
    ).toBeInTheDocument();
    expect(screen.getByText("VS")).toBeInTheDocument();
  });
});
