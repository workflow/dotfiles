# GUI for PipeWire effects
{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/easyeffects"
    ];
  };

  # Preset from https://github.com/JackHack96/EasyEffects-Presets/blob/master/Bass%20Enhancing%20%2B%20Perfect%20EQ.json
  home.file.".config/easyeffects/autoload/output/bass-enhancing-perfect-eq.json".source = ./presets/output/bass-enhancing-perfect-eq.json;
  # IRS file from the same repo above
  home.file.".config/easyeffects/irs/Razor Surround ((48k Z-Edition)) 2.Stereo +20 bass.irs".source = ./presets/irs/razor-surround-48k-z-edition-stereo-plus20-bass.irs;

  services.easyeffects = {
    enable = true;
    preset = "bass-enhancing-perfect-eq";
  };
}
