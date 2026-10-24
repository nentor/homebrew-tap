cask "deepseek-harness" do
  version "0.2.1-rc.3-20261024"
  sha256 "5184c8ca35c70535779ddce7e3df1148ee5a352702042f9707ae7a3a352b339b"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/desktop-2026-10-24/deepseek-harness-0.2.1-rc.3-mac-arm64-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
