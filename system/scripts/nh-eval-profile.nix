{pkgs}:
pkgs.writeShellApplication {
  name = "nh-eval-profile";
  runtimeInputs = with pkgs; [
    perf
    flamegraph
    gnugrep
    coreutils
    gawk
    findutils
    util-linux
    git
    which
    gzip
  ];
  text = ''
    set -euo pipefail

    if [ $# -lt 1 ]; then
      echo "Usage: nh-eval-profile <host> [extra nh args]" >&2
      exit 1
    fi

    host="$1"
    shift || true

    outdir="result-profile"
    mkdir -p "$outdir"

    # nh os switch syntax: nh os switch [FLAGS] [INSTALLABLE] [-- EXTRA_ARGS]
    # We use --dry (-n) to avoid building/activating, only evaluate
    cmd=(nh os switch --dry ".#nixosConfigurations.$host")

    if [ "$#" -gt 0 ]; then
      cmd+=(--)
      cmd+=("$@")
    fi

    perfdata="$outdir/perf.data"
    echo "Profiling evaluation with perf..."
    echo "Running: ''${cmd[*]}"
    sleep 1
    if ! perf record -F 997 -g -o "$perfdata" -- "''${cmd[@]}"; then
      echo "perf record failed; you may need to run: sudo sysctl kernel.perf_event_paranoid=1" >&2
      exit 1
    fi
    sleep 1

    echo "Generating folded stacks..."
    folded="$outdir/stacks.folded"
    if ! perf script -i "$perfdata" 2>/dev/null | stackcollapse-perf.pl > "$folded"; then
      echo "Failed to collapse stacks." >&2
      exit 1
    fi

    echo "Rendering flamegraph SVG..."
    svg="$outdir/nh-eval-flamegraph.svg"
    if ! flamegraph.pl --countname=samples --title "nh os switch eval flamegraph ($host)" "$folded" > "$svg"; then
      echo "Failed to render flamegraph." >&2
      exit 1
    fi

    echo ""
    echo "Flamegraph written to: $svg"
    echo "Perf data: $perfdata"
    echo "You can open the SVG in your browser to inspect hotspots."
  '';
}
