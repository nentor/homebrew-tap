cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-rc.1-no-telemetry"
  sha256 arm: "85d5e3e0b2660d2a0c253f187c80586ff913a2396c74e74bb2380b068b2a1433", intel: "bde28bdf3a6d32ef303cd336a2868464dd22c87d913f4690c35af7c00230ef06"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-rc.1/deepseek-harness-0.2.2-rc.1-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
