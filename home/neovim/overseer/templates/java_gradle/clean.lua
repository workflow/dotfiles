local overseer_lib = require("overseer_lib")

return {
  name = "gradlew: clean",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "clean" },
    }
  end,
  condition = {
    callback = function(search)
      return overseer_lib.is_gradle_project(search.dir)
    end,
  }
}
