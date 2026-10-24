# Matt Pocock's engineering skills: https://github.com/mattpocock/skills
#
# The skill set is whatever upstream's Claude plugin manifest promotes, so
# in-progress/misc/deprecated skills stay out on every agent. Claude Code loads
# the repo as a plugin, which namespaces the skills (/mattpocock-skills:code-review)
# instead of shadowing its built-in /code-review.
{inputs, ...}: {
  flake.modules.homeManager.mattpocock-skills = {lib, ...}: let
    src = inputs.mattpocock-skills;
    manifest = lib.importJSON "${src}/.claude-plugin/plugin.json";

    skills = lib.listToAttrs (map skillEntry manifest.skills);
    skillEntry = relPath: let
      dir = "${src}/${relPath}";
    in
      assert lib.assertMsg (builtins.pathExists "${dir}/SKILL.md") "mattpocock-skills: ${relPath} has no SKILL.md";
        lib.nameValuePair (baseNameOf relPath) dir;
  in {
    programs.claude-code.plugins = ["${src}"];
    programs.opencode.skills = skills;
    dendrix.codex.skills = skills;
  };
}
