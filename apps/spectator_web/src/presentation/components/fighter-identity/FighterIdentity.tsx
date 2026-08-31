import type { FighterIdentityModel } from "../../types.ts";

interface FighterIdentityProps {
  identity: FighterIdentityModel;
  variant?: "compact" | "matchup" | "hero";
  reverse?: boolean;
}

export function FighterIdentity({
  identity,
  variant = "compact",
  reverse = false,
}: FighterIdentityProps) {
  const classes = [
    "identity",
    `identity--${variant}`,
    variant !== "compact" ? "identity--vertical" : "",
    reverse ? "identity--reverse" : "",
  ]
    .filter(Boolean)
    .join(" ");
  const semanticLabel = `${identity.fighterName}, ${identity.nickname}${identity.guest ? ", гость" : ""}`;

  return (
    <article className={classes} aria-label={semanticLabel}>
      {identity.fighterAssetPath === undefined ? (
        <div
          className="identity__art identity__art--missing"
          aria-hidden="true"
        />
      ) : (
        <img className="identity__art" src={identity.fighterAssetPath} alt="" />
      )}
      <div className="identity__copy">
        <p className="identity__fighter">{identity.fighterName}</p>
        <p className="identity__nickname">{identity.nickname}</p>
        {identity.guest && <span className="identity__guest">Гость</span>}
      </div>
    </article>
  );
}
