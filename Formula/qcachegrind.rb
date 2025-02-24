class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/21.08.0/src/kcachegrind-21.08.0.tar.xz"
  sha256 "7d09007ed2e91fe54e45956f40551938e528238e4f4c0a84ca6285ea497125af"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "39b135df00ce86f949a5c58753970602b8ca52b89905d0ef615baa87653f3cc6"
    sha256 cellar: :any, big_sur:       "5b7391fa51573d5b765d96cb417d08367e6fc448316669911048aa952415da5d"
    sha256 cellar: :any, catalina:      "c7f690556d97574bff930742e32990a5eb15376f68f36aa7c95c14c199f90953"
    sha256 cellar: :any, mojave:        "a9ccb266114b35cb9ae83a94533355e4c0dc05489a6bd3972e1f1f6469ac56e8"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  def install
    spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
    spec << "-arm64" if Hardware::CPU.arm?
    cd "qcachegrind" do
      system "#{Formula["qt@5"].opt_bin}/qmake", "-spec", spec,
                                               "-config", "release"
      system "make"

      on_macos do
        prefix.install "qcachegrind.app"
        bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
      end

      on_linux do
        bin.install "qcachegrind/qcachegrind"
      end
    end
  end
end
