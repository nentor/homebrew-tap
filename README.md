# nentor/homebrew-tap

Personal Homebrew tap for the no-telemetry DeepSeek Harness fork
(`nentor/deepseek-harness-no-telemetry`).

## Use

```sh
brew tap nentor/tap
brew install --cask deepseek-harness   # Desktop app + `dsh` CLI shim
# or, for headless machines:
brew install dsh                        # standalone `dsh` CLI only (source build)
```

Install the cask **or** the formula, not both: each provides a `dsh`
binary and Homebrew will refuse to link the second one.

## Releases

Both artifacts track **stable** `dsh-v<VERSION>-no-telemetry` releases, cut by
`fork-versioned-release.yml` (package versions stay identical to upstream; the
`-no-telemetry` marker lives on the tag and release only). The rolling
`desktop-YYYY-MM-DD` prereleases stay off the tap.

- `Casks/deepseek-harness.rb` — Desktop installers plus a `binary` shim that
  exposes the Desktop-bundled CLI (`Contents/Resources/runtime/cli/bin/dsh`,
  runs under the app's Electron runtime) as `dsh`.
- `Formula/dsh.rb` — builds the CLI from source (`pnpm install` +
  `pnpm run build:official` + `pnpm deploy`) against Homebrew `node@24` and
  links a plain-node `dsh` wrapper. No npm publish, no Desktop required.

## Notes

- Desktop builds are unsigned: after cask install, clear quarantine before
  first launch:
  `xattr -dr com.apple.quarantine "/Applications/Deep Seek Harness.app"`
- The `mac-x64` (Intel) DMG is only published when that packaging leg
  succeeds; otherwise the cask is arm64-only until the next green build.
