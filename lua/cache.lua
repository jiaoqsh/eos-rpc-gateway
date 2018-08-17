local _M = {}

-- alternatively: local lrucache = require "resty.lrucache.pureffi"
local lrucache = require "resty.lrucache"
-- we need to initialize the cache on the Lua module level so that
-- it can be shared by all the requests served by each nginx worker process:
local cache = lrucache.new(100) -- allow up to 100 items in the cache
if not cache then
    return ngx.log(ngx.ERR, "failed to create the cache: " .. (err or "unknown"))
end

function _M.set(key, value)
    cache:set(key, value)
end

function _M.get(key)
    local value = cache:get(key)
    if not value then
        ngx.log(ngx.ERR, "failed to get from cache: ", "key=" .. key)
    end
    return value
end

return _M


