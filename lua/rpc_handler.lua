local _M = {}

local log = ngx.log
local ERR = ngx.ERR

local init = require "init"
local cache = require "cache"
local md5 = require "md5"
local cjson = require "cjson";
local http = require "resty.http"

local conf = init.get_config()

function _M.call()
    for i, rpc in ipairs(conf.rpc_list) do
        _M.execute(conf.uri, conf.method, rpc)
    end
end

function _M.execute(uri, method, rpc)
    local url = uri .. rpc.api
    local body = cjson.encode(rpc.body)
    local res, err = _M.request(url, method, body)
    if not res then
        log(ERR, "failed to request:", err)
    else
        if 200 == res.status then
            --log(ERR, "success to request:", res.body)
            local key = md5.get(rpc.api .. cjson.encode(rpc.body))
            cache.set(key, res.body)
        end
    end
end

function _M.request(url, method, body)
    local httpc = http.new()
    httpc:set_timeout(1500)
    local res, err = httpc:request_uri(url, {
        method = method,
        body = body,
        headers = {
            ["User-Agent"] = "Gateway/1.0",
            ["Content-Type"] = "application/json",
        }
    })
    return res, err
end

return _M

