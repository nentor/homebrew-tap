cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-alpha.2-no-telemetry"
  sha256 arm: "c38f3e17878093a06f1c25055d027b4ea29136934c102959dec84b86a6d0ec3b", intel: "703f1ce2371ece9596c16904be5c25de3c87b8605d1942c120aa12d3173adddd"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-alpha.2-no-telemetry/deepseek-harness-0.2.2-alpha.2-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
