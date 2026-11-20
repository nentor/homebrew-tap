cask "deepseek-harness" do
  arch arm: "arm64", intel: "x64"
  version "0.2.2-rc.5-no-telemetry"
  sha256 arm: "fff38e8783a7baeeebcf556b942180b9b2befa60176407266407b58656ae30f6", intel: "9f18fe3b580b3e54c1bf2899d17ec322b5da622098f52e6b7a146468bc9b4dc0"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/releases/download/dsh-v0.2.2-rc.5/deepseek-harness-0.2.2-rc.5-mac-#{arch}-unsigned.dmg"
  name "DeepSeek Harness (no telemetry)"
  desc "DeepSeek agent-harness desktop, forked with outbound telemetry removed"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  app "DeepSeek Harness.app"
  binary "#{appdir}/DeepSeek Harness.app/Contents/Resources/runtime/cli/bin/dsh", target: "dsh"
  caveats "Unsigned build: clear quarantine before first launch: xattr -dr com.apple.quarantine /Applications/Deep Seek Harness.app"
end
