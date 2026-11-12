cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-rc.2-no-telemetry"
  sha256 arm: "a29e8ca0d64e5112b37f6b766931529314b95366a0acc0bb146d4c39432ce8ef", intel: "69bde7bb7523a0a2e256ebf579b614fbda7efb5452524e8c849bf7acba9ebbba"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-rc.2/deepseek-harness-0.2.2-rc.2-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
