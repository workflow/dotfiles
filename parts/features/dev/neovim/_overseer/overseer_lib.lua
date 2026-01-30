local M = {}

M.is_gradle_project = function(dir)
  while dir ~= "" and dir ~= "/" do
    if vim.fn.filereadable(dir .. "/gradlew") == 1 then
      return true
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  return false
end

M.is_maven_project = function(dir)
  while dir ~= "" and dir ~= "/" do
    if vim.fn.filereadable(dir .. "/pom.xml") == 1 then
      return true
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  return false
end

return M
