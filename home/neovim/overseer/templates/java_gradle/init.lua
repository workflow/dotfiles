local overseer_lib = require("overseer_lib")

return {
  generator = function(search)
    if not overseer_lib.is_gradle_project(search.dir) then
      return {}
    end

    return {
      {
        name = "gradlew: build",
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = { "build" },
          }
        end,
      },
      {
        name = "gradlew: test",
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = { "test" },
          }
        end,
      },
      {
        name = "gradlew: clean",
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = { "clean" },
          }
        end,
      },
      {
        name = "gradlew: bootRun",
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = { "bootRun" },
          }
        end,
      },
      {
        name = "gradlew: spotlessApply",
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = { "spotlessApply" },
          }
        end,
      },
    }
  end,
}
