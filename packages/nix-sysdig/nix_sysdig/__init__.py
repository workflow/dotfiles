import argparse
import signal
import subprocess
import sys
from typing import List


def record_command(args: argparse.Namespace) -> None:
    # sudo sysdig -w build.scap
    package = str(args.package)
    sysdig_filter = (
        "thread.cgroup.pids=/system.slice/nix-daemon.service and user.uid=1000"
    )
    trace_file = "all-packages.scap"
    if package != "*":
        trace_file = f"{package}.scap"
        sysdig_filter += f" and proc.env contains {package}"
    try:
        cmd = ["sysdig", "-w", trace_file, sysdig_filter]
        proc = subprocess.Popen(cmd)
        print("Hit Ctrl-C to stop recording", file=sys.stderr)
        proc.wait()
    except KeyboardInterrupt:
        proc.terminate()
        proc.wait()
        print(f"written to {trace_file}", file=sys.stderr)


def replay_command(args: argparse.Namespace) -> None:
    subprocess.run(["sysdig", "-r", args.tracefile] + args.extra_filter)


def parse_args(command: str, args: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog=command, formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    subparsers = parser.add_subparsers(
        dest="subcommand",
        title="subcommands",
        description="valid subcommands",
        help="use --help on the additional subcommands",
    )
    subparsers.required = True  # type: ignore

    record_parser = subparsers.add_parser("record", help="record system calls of nix build")
    record_parser.add_argument(
        "package", type=str, default="*", help="Package attribute to record"
    )
    record_parser.set_defaults(func=record_command)

    replay_parser = subparsers.add_parser("replay", help="replay system calls")
    replay_parser.add_argument(
        "tracefile", type=str, help="Package attribute to record"
    )
    replay_parser.add_argument(
        "extra_filter", type=str, nargs="*", help="Package attribute to record"
    )
    replay_parser.set_defaults(func=replay_command)

    return parser.parse_args(args)


def main():
    args = parse_args(sys.argv[0], sys.argv[1:])
    args.func(args)


if __name__ == "__main__":
    main()
