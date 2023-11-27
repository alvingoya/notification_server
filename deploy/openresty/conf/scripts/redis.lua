local redis_host = "18.138.68.138"
local redis_password = "4AaB!O4c%EdN^$Zn"
local redis_database = 2
local redis_pubsub_channel = "sse:notification"

local function connect_subscribe()
    local redis = require "resty.redis"
    local red = redis:new()
    red:set_timeouts(1000, 1000, 1000) -- 1 sec

    local ok, err1 = red:connect(redis_host, 6379)
    if not ok then
        ngx.log(ngx.ERR, "Failed to connect to Redis: ", err1)
        return
    end
    local conn_res, err2 = red:auth(redis_password)
    if not conn_res then
        ngx.log(ngx.ERR, "Failed to authenticate: ", err2)
        return
    end

    red:select(redis_database)

    local pub_res, err3 = red:subscribe(redis_pubsub_channel)

    if not pub_res then
        ngx.log(ngx.ERR, "Failed to subscribe to channel: ", err3)
        return ngx.exit(500)
    end
    local ngx.shared.redis_pubsub_conn:set("redis_pubsub_connection", red)
end

local function get_connection()
    local ngx.shared.redis_pubsub_conn:set("redis_pubsub_connection", red)

end

local cjson = require "cjson"
