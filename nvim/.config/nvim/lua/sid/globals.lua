P = function(v)
  print(vim.inspect(v))
  return v
end

REALOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  REALOAD(name)
  return require(name)
end
