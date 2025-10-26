class Rsync < Formula
  desc "Rsync with --no-i-r-skip-unchanged for accurate progress on resumed transfers"
  homepage "https://github.com/RyuX51/rsync"
  url "https://github.com/RyuX51/rsync.git", branch: "pr-no-i-r-skip-unchanged"
  version "3.4.1-no-i-r-skip-unchanged"
  head "https://github.com/RyuX51/rsync.git", branch: "pr-no-i-r-skip-unchanged"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Generate configure script
    system "./prepare-source", "build"
    
    # Configure with minimal dependencies and disable man page generation
    system "./configure", "--disable-openssl",
                          "--disable-xxhash",
                          "--disable-zstd",
                          "--disable-lz4",
                          "--disable-md2man",
                          "--prefix=#{prefix}"
    
    # Build and install
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This is a custom build of rsync with the --no-i-r-skip-unchanged option.
      
      Usage:
        rsync -av --no-i-r-skip-unchanged --info=progress2 src/ dest/
      
      This provides accurate 0-100% progress on resumed transfers.
      
      To use instead of system rsync, add to your shell profile:
        alias rsync='#{bin}/rsync'
    EOS
  end

  test do
    system "#{bin}/rsync", "--version"
    assert_match "no-i-r-skip-unchanged", shell_output("#{bin}/rsync --help")
  end
end
