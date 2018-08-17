local delay = 1 -- in seconds
local new_timer = ngx.timer.at
local log = ngx.log
local ERR = ngx.ERR

local rpc_handler = require "rpc_handler"

local handler
-- do some routine job in Lua just like a cron job
handler = function()
    --log(ERR, "start get rpc data ", "worker_id="..ngx.worker.id())
    rpc_handler.call()

    local ok, err = new_timer(delay, handler)
    if not ok then
        log(ERR, "failed to create the timer: ", err)
        return
    end
end

local ok, err = new_timer(delay, handler)
if not ok then
    log(ERR, "failed to create the timer: ", err)
    return
end



