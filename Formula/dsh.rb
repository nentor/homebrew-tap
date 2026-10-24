class Dsh < Formula
  desc "dsh CLI from the no-telemetry DeepSeek Harness fork"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/archive/refs/tags/desktop-2026-10-24.tar.gz"
  sha256 "b8b14c68d2abb819052bf40454a655e25adafbef8c27b1e285fa0c219399f95b"
  version "0.2.1-rc.3-20261024"
  license "MIT"
  depends_on "node@24"
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "run", "build:official"
    system "pnpm", "--filter", "@deepseek-ai/dsh", "deploy", "--legacy", "--prod",
            "--config.allow-unused-patches=true", "--config.node-linker=hoisted",
            "--config.auto-install-peers=false", "--config.link-workspace-packages=true",
            "--config.hoist-workspace-packages=false", libexec
    (bin/"dsh").write <<~EOS
      #!/bin/sh
      # Standalone dsh on plain node (Desktop ships its own Electron-based launcher).
      exec "#{Formula["node@24"].opt_bin}/node" "#{libexec}/lib/bin.js" "$@"
    EOS
    chmod 0755, bin/"dsh"
  end

  test do
    assert_match "0.2.1-rc.3", shell_output("#{bin}/dsh --version")
  end
end
