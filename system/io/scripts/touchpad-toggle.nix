# Toggle Touchpad enabled/disabled based on external mouse connection status
{pkgs, ...}:
pkgs.writeShellApplication {
  name = "touchpad-toggle";

  runtimeInputs = [pkgs.xorg.xinput];

  text = ''
    # Xinput requires access to the XServer to run
    export DISPLAY=":0"
    export XAUTHORITY="/home/farlion/.Xauthority"

    touchpad_id=$(xinput list --id-only "DELL098F:00 04F3:311C Touchpad")

    for battery in /sys/class/power_supply/hidpp_battery_*/; do
      device_name=$(cat "$battery/model_name" 2> /dev/null)
      if echo "$device_name" | grep -iq "M720 Triathlon"; then
        battery_status=$(cat "$battery/online" 2> /dev/null)
        break
      fi
    done

    if [ "''${battery_status:-0}" == "1" ]; then
        xinput disable "$touchpad_id"
    else
        xinput enable "$touchpad_id"
    fi
  '';
}
