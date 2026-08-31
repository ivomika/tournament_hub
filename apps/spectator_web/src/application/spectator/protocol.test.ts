import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { parseProjection, parseProjectionEvent } from "./protocol.ts";
import { projectionFixture } from "./testFixture.ts";

describe("Spectator protocol v1", () => {
  it("читает канонические snapshot и event fixtures из docs", () => {
    const fixturePath = resolve(
      process.cwd(),
      "../../docs/data/fixtures/spectator-protocol-v1.json",
    );
    const fixture = JSON.parse(readFileSync(fixturePath, "utf8")) as {
      snapshot: unknown;
      event: unknown;
    };

    expect(parseProjection(fixture.snapshot).ok).toBe(true);
    expect(parseProjectionEvent(fixture.event).ok).toBe(true);
  });

  it("принимает allowlisted projection", () => {
    expect(parseProjection(projectionFixture)).toEqual({
      ok: true,
      value: projectionFixture,
    });
  });

  it("отклоняет unknown/private fields и неизвестную версию", () => {
    expect(
      parseProjection({ ...projectionFixture, profileId: "private" }),
    ).toEqual({
      ok: false,
      code: "INVALID_PAYLOAD",
    });
    expect(
      parseProjection({ ...projectionFixture, snapshotVersion: 2 }),
    ).toEqual({
      ok: false,
      code: "INCOMPATIBLE_VERSION",
    });
  });

  it("валидирует replace-only event envelope", () => {
    const event = {
      category: "event",
      type: "spectator.projection.replaced",
      protocolVersion: 1,
      eventVersion: 1,
      eventId: "e-7",
      tournamentId: "t-1",
      sequence: 7,
      timestamp: "2026-08-30T12:00:00Z",
      payload: { projection: projectionFixture },
    };
    expect(parseProjectionEvent(event).ok).toBe(true);
    expect(
      parseProjectionEvent({ ...event, type: "tournament.command" }).ok,
    ).toBe(false);
  });
});
