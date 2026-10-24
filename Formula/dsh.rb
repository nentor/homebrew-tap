class Dsh < Formula
  desc "Agent-harness CLI (no-telemetry fork)"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/archive/refs/tags/desktop-2026-10-24.tar.gz"
  version "0.2.1-rc.3-20261024"
  sha256 "385767d3dc44089596b904dea29aff1494eae70761e1aae46e85d40f90844691"
  license "MIT"
  depends_on "pnpm" => :build
  depends_on "node@24"

  def install
    # Tag tarballs carry no .git metadata; the build accepts the commit explicitly.
    ENV["DSH_CLIENT_COMMIT_HASH"] = "785de4f"
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "run", "build:official"
    # Default deploy (isolated linker, auto-installed peers): the dsh closure
    # carries the vendored framework as peer dependencies, which the exe-style
    # legacy/hoisted flags drop from the staged tree.
    system "pnpm", "--filter", "@deepseek-ai/dsh", "deploy", "--prod",
                    "--config.allow-unused-patches=true", libexec
    (bin/"dsh").write <<~EOS
      #!/bin/sh
      # Standalone dsh on plain node (Desktop ships its own Electron-based launcher).
      exec "#{formula_opt_bin("node@24")}/node" "#{libexec}/lib/bin.js" "$@"
    EOS
    chmod 0755, bin/"dsh"
  end

  test do
    assert_match "0.2.1-rc.3", shell_output("#{bin}/dsh --version")
  end
end
