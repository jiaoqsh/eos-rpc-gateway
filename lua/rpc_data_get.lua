local log = ngx.log
local ERR = ngx.ERR


local cache = require "cache"
local md5 = require "md5"
local cjson = require "cjson";
local init = require "init"
local rpc_handler = require "rpc_handler"
local conf = init.get_config()

local function is_empty(s)
    return s == nil or s == ''
end

local function is_config_rpc(key_data)
    for i, rpc in ipairs(conf.rpc_list) do
        if key_data == rpc.api .. cjson.encode(rpc.body) then
            return true
        end
    end
    return false
end


local body_data_json = ngx.req.get_body_data()
if is_empty(body_data_json) then
    log(ERR, "failed to get_body_data")
    body_data_json = ngx.req.get_body_file()
end

local key_data = ngx.var.uri .. body_data_json
if is_config_rpc(key_data) then
    local key = md5.get(key_data)
    if not is_empty(key) then
        local res = cache.get(key)
        if res ~= nil then
            ngx.say(res)
            return
        end
    end
end

local url = conf.uri .. ngx.var.uri
local res, err = rpc_handler.request(url, ngx.var.request_method, body_data_json)
if not res then
    log(ERR, "failed to request:", err)
    ngx.say(err)
    return
end
ngx.say(res.body)


