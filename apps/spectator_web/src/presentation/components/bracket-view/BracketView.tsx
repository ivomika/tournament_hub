import {
  useEffect,
  useRef,
  useState,
  type KeyboardEvent,
  type PointerEvent,
  type WheelEvent,
} from "react";
import type { MatchModel, TournamentFormatId } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";
import { buildBracketLanes } from "./bracketModel.ts";

const zoomStep = 0.25;
const minimumZoom = 0.5;
const maximumZoom = 2;
const keyboardPanStep = 64;

function BracketMatch({ match }: { match: MatchModel }) {
  return (
    <article
      className="bracket-match surface"
      data-state={match.state}
      aria-label={`${match.label}: ${match.first.fighterName}, ${match.first.nickname}, против ${match.second.fighterName}, ${match.second.nickname}`}
    >
      <p className="stage-label">{match.label}</p>
      <div className="bracket-match__row">
        <FighterIdentity identity={match.first} />
        <strong>{match.score?.[0] ?? "—"}</strong>
      </div>
      <div className="bracket-match__row">
        <FighterIdentity identity={match.second} />
        <strong>{match.score?.[1] ?? "—"}</strong>
      </div>
    </article>
  );
}

export function BracketView({
  formatId,
  matches,
}: {
  formatId: TournamentFormatId;
  matches: readonly MatchModel[];
}) {
  const lanes = buildBracketLanes(formatId, matches);
  const viewportRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLDivElement>(null);
  const dragRef = useRef<
    | {
        pointerId: number;
        x: number;
        y: number;
        offsetX: number;
        offsetY: number;
      }
    | undefined
  >(undefined);
  const [zoom, setZoom] = useState(1);
  const [offset, setOffset] = useState({ x: 0, y: 0 });
  const [isFullscreen, setIsFullscreen] = useState(false);

  useEffect(() => {
    const onFullscreenChange = () =>
      setIsFullscreen(document.fullscreenElement === viewportRef.current);
    document.addEventListener("fullscreenchange", onFullscreenChange);
    return () =>
      document.removeEventListener("fullscreenchange", onFullscreenChange);
  }, []);

  const updateZoom = (next: number) =>
    setZoom(Math.min(maximumZoom, Math.max(minimumZoom, next)));
  const reset = () => {
    setZoom(1);
    setOffset({ x: 0, y: 0 });
  };
  const fit = () => {
    const viewport = viewportRef.current;
    const canvas = canvasRef.current;
    if (viewport === null || canvas === null) return reset();
    const horizontal = viewport.clientWidth / canvas.scrollWidth;
    const vertical = viewport.clientHeight / canvas.scrollHeight;
    updateZoom(Math.min(1, horizontal || 1, vertical || 1));
    setOffset({ x: 0, y: 0 });
  };
  const toggleFullscreen = async () => {
    if (document.fullscreenElement === viewportRef.current) {
      await document.exitFullscreen();
    } else {
      await viewportRef.current?.requestFullscreen();
    }
  };
  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    switch (event.key) {
      case "+":
      case "=":
        updateZoom(zoom + zoomStep);
        break;
      case "-":
        updateZoom(zoom - zoomStep);
        break;
      case "0":
        reset();
        break;
      case "f":
      case "F":
        void toggleFullscreen();
        break;
      case "ArrowLeft":
        setOffset((value) => ({ ...value, x: value.x + keyboardPanStep }));
        break;
      case "ArrowRight":
        setOffset((value) => ({ ...value, x: value.x - keyboardPanStep }));
        break;
      case "ArrowUp":
        setOffset((value) => ({ ...value, y: value.y + keyboardPanStep }));
        break;
      case "ArrowDown":
        setOffset((value) => ({ ...value, y: value.y - keyboardPanStep }));
        break;
      default:
        return;
    }
    event.preventDefault();
  };
  const onPointerDown = (event: PointerEvent<HTMLDivElement>) => {
    dragRef.current = {
      pointerId: event.pointerId,
      x: event.clientX,
      y: event.clientY,
      offsetX: offset.x,
      offsetY: offset.y,
    };
    event.currentTarget.setPointerCapture(event.pointerId);
  };
  const onPointerMove = (event: PointerEvent<HTMLDivElement>) => {
    const drag = dragRef.current;
    if (drag === undefined || drag.pointerId !== event.pointerId) return;
    setOffset({
      x: drag.offsetX + event.clientX - drag.x,
      y: drag.offsetY + event.clientY - drag.y,
    });
  };
  const endPointer = (event: PointerEvent<HTMLDivElement>) => {
    if (dragRef.current?.pointerId !== event.pointerId) return;
    dragRef.current = undefined;
    event.currentTarget.releasePointerCapture(event.pointerId);
  };
  const onWheel = (event: WheelEvent<HTMLDivElement>) => {
    event.preventDefault();
    updateZoom(zoom + (event.deltaY < 0 ? zoomStep : -zoomStep));
  };

  return (
    <section
      className="bracket-viewport"
      ref={viewportRef}
      aria-label="Структура турнира"
      onKeyDown={onKeyDown}
    >
      <div className="bracket-toolbar" aria-label="Управление масштабом">
        <button type="button" onClick={() => updateZoom(zoom - zoomStep)}>
          Уменьшить
        </button>
        <output aria-live="polite">{Math.round(zoom * 100)}%</output>
        <button type="button" onClick={() => updateZoom(zoom + zoomStep)}>
          Увеличить
        </button>
        <button type="button" onClick={fit}>
          Вписать
        </button>
        <button type="button" onClick={reset}>
          Сбросить
        </button>
        <button type="button" onClick={() => void toggleFullscreen()}>
          {isFullscreen ? "Выйти из полноэкранного режима" : "На весь экран"}
        </button>
      </div>
      <div
        className="bracket-pan-area"
        tabIndex={0}
        aria-label="Полотно сетки. Стрелки перемещают, плюс и минус меняют масштаб, 0 сбрасывает, F включает полноэкранный режим."
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={endPointer}
        onPointerCancel={endPointer}
        onWheel={onWheel}
      >
        <div
          className="bracket-canvas"
          ref={canvasRef}
          style={{
            transform: `translate(${offset.x}px, ${offset.y}px) scale(${zoom})`,
          }}
        >
          {lanes.map((lane) => (
            <section
              className="bracket-lane"
              data-kind={lane.kind}
              key={lane.id}
              aria-labelledby={`bracket-lane-${lane.id}`}
            >
              <h4
                className="bracket-lane__title"
                id={`bracket-lane-${lane.id}`}
              >
                {lane.label}
              </h4>
              {lane.kind === "losers" && (
                <p className="bracket-lane__transfer">
                  Переходы после поражения
                </p>
              )}
              <div className="bracket-lane__rounds">
                {lane.rounds.map((round) => (
                  <section className="bracket-round" key={round.id}>
                    <h5 className="bracket-round__title">{round.label}</h5>
                    <div className="bracket-round__matches">
                      {round.matches.map((match) => (
                        <BracketMatch key={match.id} match={match} />
                      ))}
                    </div>
                  </section>
                ))}
              </div>
            </section>
          ))}
        </div>
      </div>
    </section>
  );
}
