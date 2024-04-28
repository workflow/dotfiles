local overseer_lib = require("overseer_lib")

return {
  name = "gradlew: spotlessApply",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "spotlessApply" },
    }
  end,
  condition = {
    callback = function(search)
      return overseer_lib.is_gradle_project(search.dir)
    end,
  }
}
