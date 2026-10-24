cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.1-rc.3-no-telemetry"
  sha256 arm: "988a5668b4252d781334fd71182ebf93891b5a46849a609bdb59c2a7d543fc47", intel: "2c97d3fa32242c53b5c7309b34f271a5641063b551dfe53623179f04e76b7b45"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.1-rc.3-no-telemetry/deepseek-harness-0.2.1-rc.3-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
