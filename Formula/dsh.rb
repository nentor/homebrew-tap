require "json"

class Dsh < Formula
  desc "Agent-harness CLI (no-telemetry fork)"
  homepage "https://github.com/nentor/deepseek-harness-no-telemetry"
  url "https://github.com/nentor/deepseek-harness-no-telemetry/archive/refs/tags/dsh-v0.2.2-alpha.2-no-telemetry.tar.gz"
  version "0.2.2-alpha.2-no-telemetry"
  sha256 "72d21bd87a609a2d50d4f398d8b0119a03045121d98766a66733755893d286cb"
  license "MIT"
  depends_on "cmake" => :build
  depends_on "pnpm" => :build
  depends_on "node@24"
  # cmake is a safety net: koffi falls back to a source build when no prebuilt
  # is available (CI runners provide cmake for the same reason).

  def install
    # Tag tarballs carry no .git metadata; the build accepts the commit explicitly.
    ENV["DSH_CLIENT_COMMIT_HASH"] = "dcb47b9"
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "run", "build:official"
    # Pack the workspace and install from local tarballs exactly like CI
    # packed-install verification: every workspace dependency resolves from a
    # file: URL, so the registry can never substitute upstream builds.
    # (pnpm deploy drops the vendored peer dependencies and re-resolves
    # workspace: specs against the registry.)
    # The mapping is inlined (rather than calling the repo helper script) so
    # generated formulas also build tag trees that predate the helper.
    system "pnpm", "run", "release:pack", "--family", "dsh", "--out", "dist/npm"
    system "pnpm", "run", "release:pack", "--family", "vendor", "--out", "dist/npm-vendor"
    system "pnpm", "--dir", "native/system", "run", "build:ts"
    system "pnpm", "--dir", "native/system/packages/entry", "pack",
                    "--pack-destination", "#{buildpath}/dist/npm-landlock"
    consumer = {
      "name"                 => "dsh-brew-consumer",
      "version"              => "0.0.0",
      "private"              => true,
      "dependencies"         => {},
      "optionalDependencies" => {},
    }
    os = RUBY_PLATFORM.include?("darwin") ? "darwin" : "linux"
    arch = (RUBY_PLATFORM.include?("arm64") || RUBY_PLATFORM.include?("aarch64")) ? "arm64" : "x64"
    accept = lambda do |value, current|
      return true if value.nil?

      valid = value.is_a?(Array) && value.all?(String)
      raise "packed platform constraints must be arrays of strings" unless valid

      accepted = value.all? { |t| t.start_with?("!") }
      value.each do |tag|
        return false if tag == "!#{current}"

        accepted = true if tag == current || (tag == "any" && value.length == 1)
      end
      accepted
    end
    Dir["dist/npm/*.tgz", "dist/npm-vendor/*.tgz", "dist/npm-landlock/*.tgz"].sort.each do |tgz|
      manifest = JSON.parse(Utils.safe_popen_read("tar", "-xzf", tgz, "-O", "package/package.json"))
      name = manifest["name"]
      raise "packed tarball manifest lacks name" unless name.is_a?(String)

      compatible = accept.call(manifest["os"], os) && accept.call(manifest["cpu"], arch)
      key = compatible ? "dependencies" : "optionalDependencies"
      consumer[key][name] = "file://#{File.expand_path(tgz)}"
    end
    raise "no packed tarballs found" if consumer["dependencies"].empty?

    (libexec/"package.json").write(JSON.generate(consumer))
    # Local consumer install, not a global pack install, so the global-style
    # std_npm_args helper does not apply here. Optionals stay enabled: npm
    # skips foreign-platform ones by os/cpu, while the current platform prebuilt
    # optionals (e.g. koffi) must install.
    system "npm", "install", "--prefix=#{libexec}", "--cache=#{buildpath}/.npm-cache",
                    "--no-audit", "--no-fund", "--package-lock=false"
    # Drop bundled foreign-arch macOS prebuilds (e.g. node-pty, pi-tui ship
    # per-arch directories; Homebrew rejects non-native binaries in the
    # prefix). The loader selects by platform and arch, so a foreign-arch
    # directory can never be used on this host.
    foreign =
      if OS.mac?
        [Hardware::CPU.arm? ? "darwin-x64" : "darwin-arm64"]
      else
        %w[darwin-x64 darwin-arm64]
      end
    foreign.each do |dir_name|
      Dir.glob(libexec/"node_modules/**/#{dir_name}").each do |path|
        rm_r path if File.directory?(path)
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
    assert_match "0.2.2-alpha.2", shell_output("#{bin}/dsh --version")
  end
end
