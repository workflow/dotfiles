local overseer_lib = require("overseer_lib")

return {
  generator = function(search)
    if not overseer_lib.is_maven_project(search.dir) then
      return {}
    end

    return {
      {
        name = "mvn: test",
        builder = function()
          return {
            cmd = { "mvn" },
            args = { "test" },
          }
        end,
      },
      {
        name = "mvn: clean package",
        builder = function()
          return {
            cmd = { "mvn" },
            args = { "clean", "package" },
          }
        end,
      },
    }
  end,
}
