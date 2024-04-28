local overseer_lib = require("overseer_lib")

return {
  name = "gradlew: test",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "test" },
    }
  end,
  condition = {
    callback = function(search)
      return overseer_lib.is_gradle_project(search.dir)
    end,
  }
}
