![Engine](https://img.shields.io/badge/Engine-Godot-blue)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)
![Language](https://img.shields.io/badge/Language-GDScript-orange)

# Vannsimulator

## Dette prosjektet er en partikkelbasert væskesimulering laget i Godot 4.6. Simulasjonen er inspirert av _Sebastian Lague_ på youtube

## Hvordan fungerer det?

Hundrevis av partikler **frastøter hverandre** når de kommer for nære. Partiklene reagerer på tyngdekraft, spretter av vegger og reagerer på musebevegelser. Fargen på hver partikkel indikerer hastigheten — fra 🔵 blå (sakte) til 🟡 gul til 🔴 rød (rask).

## Kontroller

- **Venstreklikk (hold):** Frastøt partikler fra musepekeren
- **Tab:** Vis/skjul innstillingsmeny

## Innstillingsmeny

Trykk **Tab** for å åpne menyen og justere simulasjonen i sanntid:

- **Repel Strength** — Hvor hardt partikler skyver hverandre unna
- **Repel Radius** — Hvor nære partikler må være for å interagere
- **Mouse Strength** — Kraften fra musefrastøtingen
- **Friction** — Hastighetsdempning per frame (`1.0` = ingen friksjon)
- **Gravity** — Nedadgående tyngdekraft

## Teknologi
- **Spillmotor:** Godot 4.6
- **Språk:** GDScript

## Struktur

```
res://
│
├── particle.tscn          # Partikkelscene
├── particle.gd            # Partikkelfysikk, veggkollisjon og fargeoppdatering
├── particle_manager.gd    # Simuleringskjerne: spatial grid, interaksjoner og tegning
├── world.tscn             # Hovedscene
├── world.gd               # Spawner partikler og kobler til UI
├── settings_ui.gd         # Sanntids-innstillingspanel (slidere)
├── control.tscn           # UI-scene
└── menu.tscn              # Menyskjerm
```

## Installasjon

Hvis du har lyst til å bare teste simulasjonen så enkelt som mulig, kan du laste ned demo-releases her:
https://github.com/WilliamNord/water-simulator/releases

`.exe`-filer er for Windows og `.dmg`-filer er for Mac.

Hvis du heller vil ha den nyeste versjonen og tilgang til alle filer og kode, kan du følge denne guiden:

1. Last ned prosjektet lokalt
   - ```git clone <repo-url>```
   - ELLER
   - Trykk på *Code* → *Download ZIP* i GitHub
2. Åpne Godot
   - Hvis du ikke har Godot eller har en utdatert versjon: https://godotengine.org/
3. Trykk *Import*
   - ELLER
   - Mac: CMD + I
   - Windows: Ctrl + I
4. Finn og velg `project.godot`-filen
5. Trykk *Import & Edit*
6. Kjør prosjektet
   - Åpne `world.tscn` og trykk **Play**-knappen i øvre høyre hjørne
   - ELLER
   - Trykk CMD + B / Ctrl + B
