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
    # Pack the workspace and install from local tarballs exactly like CI
    # packed-install verification: every workspace dependency resolves from a
    # file: URL, so the registry can never substitute upstream builds.
    # (pnpm deploy drops the vendored peer dependencies and re-resolves
    # workspace: specs against the registry.)
    system "pnpm", "run", "release:pack", "--family", "dsh", "--out", "dist/npm"
    system "pnpm", "run", "release:pack", "--family", "vendor", "--out", "dist/npm-vendor"
    system "pnpm", "--dir", "native/system", "run", "build:ts"
    system "pnpm", "--dir", "native/system/packages/entry", "pack",
                    "--pack-destination", "#{buildpath}/dist/npm-landlock"
    system "node", "scripts/release/write-consumer-manifest.mjs",
                    "--out", "#{libexec}/package.json",
                    "--from", "dist/npm", "--from", "dist/npm-vendor", "--from", "dist/npm-landlock"
    # Local consumer install, not a global pack install, so the global-style
    # std_npm_args helper does not apply here.
    system "npm", "install", "--prefix=#{libexec}", "--cache=#{buildpath}/.npm-cache",
                    "--no-audit", "--no-fund", "--package-lock=false", "--omit=optional"
    # node-pty ships prebuilds for every platform; drop the ones that cannot
    # load on this host (Homebrew rejects foreign-arch binaries in the prefix).
    prebuilds = libexec/"node_modules/node-pty/prebuilds"
    if prebuilds.directory?
      keep = "#{OS.kernel_name}-#{Hardware::CPU.arch.to_s.sub("x86_64", "x64")}"
      prebuilds.children.select(&:directory?).each do |dir|
        rm_rf dir if dir.basename.to_s != keep
      end
    end
    (bin/"dsh").write <<~EOS
      #!/bin/sh
      # Standalone dsh on plain node (Desktop ships its own Electron-based launcher).
      exec "#{formula_opt_bin("node@24")}/node" "#{libexec}/node_modules/@deepseek-ai/dsh/lib/bin.js" "$@"
    EOS
    chmod 0755, bin/"dsh"
  end

  test do
    assert_match "0.2.1-rc.3", shell_output("#{bin}/dsh --version")
  end
end
