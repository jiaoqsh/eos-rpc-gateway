local _M = {}

local resty_md5 = require "resty.md5"
local str = require "resty.string"
local log = ngx.log
local ERR = ngx.ERR

function _M.get(key)
    local md5 = resty_md5:new()
    if not md5 then
        log(ERR, "failed to create md5 object")
        return
    end
    local data = md5:update(key)
    if not data then
        log(ERR, "failed to md5 data")
        return
    end
    local digest = md5:final()
    return str.to_hex(digest)
end

return _M


