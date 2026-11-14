cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-rc.3-no-telemetry"
  sha256 arm: "48a65f6193a867b26e5294eeb011bf0bc8f4e7c01f850e569f500f63b3507782", intel: "a70c378f162ca1c3f1251cfda4f384b7a436426e64dbaed33f449c9caf719425"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-rc.3/deepseek-harness-0.2.2-rc.3-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
