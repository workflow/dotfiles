local overseer_lib = require("overseer_lib")

return {
  name = "gradlew: bootRun",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "bootRun" },
    }
  end,
  condition = {
    callback = function(search)
      return overseer_lib.is_gradle_project(search.dir)
    end,
  }
}
