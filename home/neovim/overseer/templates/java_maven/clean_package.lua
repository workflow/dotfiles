local overseer_lib = require("overseer_lib")

return {
  name = "mvn: clean package",
  builder = function()
    return {
      cmd = { "mvn" },
      args = { "clean", "package" },
    }
  end,
  condition = {
    callback = function(search)
      return overseer_lib.is_maven_project(search.dir)
    end,
  }
}
