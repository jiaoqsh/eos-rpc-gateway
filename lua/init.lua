local _M = {}

local cjson = require "cjson";

local config_file = io.open("conf/conf.json", "r");
local config_str = config_file:read("*a");
config_file:close();

local config_json = cjson.decode(config_str);

function _M.get_config()
    return config_json
end

return _M

