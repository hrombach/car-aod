# CarAOD

A tiny personal iOS app that solves one specific annoyance: my iPhone's
Always-On Display staying on (draining battery, generating extra heat)
while it's sitting on my car's wireless charging pad — even when I'm not
actually in the car with it connected to the car's Bluetooth.

There's no way to trigger "Always On Display" state changes based on
Bluetooth connectivity directly from Shortcuts, because Shortcuts has no
built-in "is my phone connected to this specific Bluetooth device" check.
This app exists purely to fill that one gap.

## What it actually does

The entire app is one App Intent: **"Is Connected to Car Bluetooth."**
It checks whether the phone's current audio output route matches a
saved Bluetooth device name (the car) and returns `true`/`false`. A
Shortcuts automation calls it and flips Always-On Display accordingly.

There is no other functionality. The on-screen UI (diagnostics list +
a text field for the car's Bluetooth name) exists only to support that
one intent — it's not meant to be a "real" app UI.

## How it's wired together

1. **Diagnostics screen** — lists the current audio route's outputs
   (`portName` / `portType`) so I could find the exact string my car
   reports over Bluetooth.
2. **Settings field** — a single `TextField` bound to `@AppStorage`,
   storing that exact device name (`UserDefaults` key:
   `carBluetoothName`) so it can be corrected without recompiling if
   the car ever reports a different name (e.g. after a firmware
   update).
3. **`IsConnectedToCarBluetoothIntent`** — reads the saved name and
   compares it against the phone's current Bluetooth audio outputs.
   `openAppWhenRun = false`, so it runs invisibly when called from
   Shortcuts.
4. **Shortcuts automations** (configured in the Shortcuts app, not in
   this repo):
   - **Plugged in + connected to car Bluetooth** → turn Always-On
     Display **on**.
   - **Unplugged** → turn Always-On Display **off** (no Bluetooth
     check needed here, since AOD can only have been turned on via the
     first automation).

## Requirements

- A physical iPhone — the simulator can't report real Bluetooth audio
  routes, so this can't be tested without real hardware.
- iOS 16+ (minimum for App Intents), 17+ recommended.
- Signed with a paid Apple Developer account so the build doesn't
  expire and need re-installing every 7 days.

## Not in scope

- No App Store submission — sideloaded for personal use only.
- No background monitoring or push notifications — the Charger
  trigger in Shortcuts does all the "waking up."
- No server component.
- No Siri phrases / Spotlight suggestions (would need an
  `AppShortcutsProvider`, intentionally skipped).

## Setup notes for future me

If the car's reported Bluetooth name ever changes (firmware update,
different phone pairing, etc.), reopen the app, check the diagnostics
list for the new exact name, and update it in the settings field —
no code changes or rebuild required.
