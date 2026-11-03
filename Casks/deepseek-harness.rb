cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-alpha.3-no-telemetry"
  sha256 arm: "b38f8c56d08195b814245f0202662d37f7917d83025b3b05faf88aed5cad5e1f", intel: "5e7a8661c18920928f37085693722b2acddd99585d54fa8755e8f909e9160668"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-alpha.3/deepseek-harness-0.2.2-alpha.3-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
