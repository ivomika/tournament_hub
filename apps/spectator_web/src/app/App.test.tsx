import "@testing-library/jest-dom/vitest";
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { App } from "./App";

describe("Приложение", () => {
  it("показывает состояние ожидания подключения", () => {
    render(<App />);

    expect(
      screen.getByRole("heading", { name: "Tournament HUB" }),
    ).toBeVisible();
    expect(screen.getByText(/ожидание сессии host/i)).toBeVisible();
  });
});
