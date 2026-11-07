# Design system ("warm and cozy")

Moved out of `CLAUDE.md` on 2026-11-07 (it was section 8 there). Changing
what this file says is changing a decision: ask Thomas first. Deviations
already agreed are in `docs/DEVIATIONS.md`.


Implement these tokens once in `nest_shared` as a `ThemeData` plus a `NestColors` theme extension. Bundle the Nunito font files as assets (do not fetch fonts at runtime).

| Token | Value | Use |
| --- | --- | --- |
| background | #F6F2EA | screen background (ivory) |
| surface | #FFFDF9 | cards, inputs, tab bar |
| surfaceAlt | #EFE9DE | admin side menu |
| chip | #ECE6DA | neutral buttons, inactive segments |
| border | #E6DFD2 | card and tab bar borders |
| borderStrong | #D6CDBD | input borders |
| divider | #F0EBE2 | rows inside cards |
| checkboxIdle | #7E8798 | unchecked boxes, dashed "add" buttons (≥3:1) |
| ink | #1F2A3D | primary text, dark buttons |
| inkMuted | #586274 | secondary text |
| accent | #1F3A5F | primary actions, checked state, To buy tiles (navy) |
| onAccent | #FFFFFF | text and icons on accent |
| accentDark | #1F3A5F | text on accent tint; accent icons and text on light surfaces |
| accentTint | #E3E8EF | active tab, shopping tint (pale blue) |
| honey / honeyInk | #E7DAC6 / #6A4E1C | meals (sand) |
| apricot / apricotInk | #C9D3E0 / #23395A | tasks (misty blue) |
| lavender / lavenderInk | #DCDDEB / #3A3F66 | watchlist (lilac) |
| rose / roseInk | #EFE2D6 / #6A3F2C | recipes (blush) |
| warning / warningInk | #F6DCD0 / #9A3B22 | overdue, backup warnings |
| rating | #F5B301 | filled rating hearts and stars (gold; an icon fill, never text) |

The palette is "Navy & ivory", chosen 2026-10-31 from side-by-side options (inspired by a navy, ivory and gold marble image). Every text pair keeps 4.5:1 (checked in `nest_shared/test/nest_colors_test.dart`). Overdue is shown as warningInk text, not a filled badge. Token names (honey, apricot, …) are kept from the first palette.

- **Type:** Nunito. Screen titles 28/800 with tight tracking (about −0.6), card titles 22/800, body 15/650, secondary 13–14/600, labels 11–12/800 with slight letter spacing. Pushed screens use a compact centred 17/800 title; tab screens draw their own large title.
- **Shape:** cards radius 22–28, tiles 22, buttons fully rounded (pill), inputs radius 18, sheets and dialogs 30, small badges radius 8–10.
- **Spacing:** 20 px screen padding, 10–16 px gaps between cards.
- **Navigation:** floating bottom tab bar (frosted, translucent white, radius 26, 16 px from the sides, 20 px from the bottom, soft floating shadow) with Home, Shopping, Meals, Tasks, Watch. Active tab: animated accentTint pill, accentDark icon and label; a light haptic tick on change. Recipes open from the dashboard and meal plan.
- **Icons:** one outline icon set (stroke about 2 px, rounded caps), for example Lucide or Tabler. The shopping catalog needs openly licensed food icons or custom ones; never copy Bring!'s icons or layout assets.
- **Surfaces:** white cards, tiles and chips have no border but a very soft shadow (`NestShadows`: ink at 4–10 %); tinted cards lie flat. Header actions are round white buttons (`NestRoundButton`).
- **Controls feel native, not Material:** iOS page transitions, no ink ripples (a quiet highlight instead), `.adaptive` switches and spinners, soft filled inputs with the label inside (sage fill while focused), filled secondary buttons instead of outlines, ink-coloured selected chips, round checkboxes, sheets with a drag handle, floating snack bars.
- **No** gradients, emoji as icons, heavy shadows or hairline outlines on cards.
- Reference mockups (Thomas has them in Claude): Dashboard, Shopping, Meal plan, Recipe, Tasks, Watchlist, Admin portal. If a screen is unclear, ask Thomas for a screenshot of the mockup.
