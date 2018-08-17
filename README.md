# EOS RPC Gateway

## V1.0
Using [OpenResty](https://openresty.org/) impl gateway
- client can call [eos query rpc](https://developers.eos.io/eosio-nodeos/reference) response from gateway cache
- gateway timing call config rpc to set cache

## QuickStart

### Install [Openresty](https://openresty.org/en/installation.html)

### Run EOS RPC Gateway
```
sudo nginx -p `pwd`/ -c conf/nginx.conf
```

### Test
get from cache
```
curl -d '{}' http://127.0.0.1/v1/chain/get_info |jq

curl -d '{"code":"eosio","scope":"eosio","json":true,"table_key":"","table":"global"}' http://127.0.0.1/v1/chain/get_table_rows |jq

curl -d '{"code":"eosio.token","symbol":"EOS"}' http://127.0.0.1/v1/chain/get_currency_stats |jq
```

get from remote
```
curl -d '{"account_name":"b1"}'  http://127.0.0.1/v1/chain/get_account |jq

curl -d '{"block_num_or_id":"10000"}'  http://127.0.0.1/v1/chain/get_block | jq
```

## nginx.conf
```
#init script: load config
init_by_lua_file lua/init.lua;
#timing call rpc to set cache
init_worker_by_lua_file lua/rpc_data_set.lua;

#server config
server {
        listen      80;
        server_name _;

        location / {
            default_type application/json;
            charset utf-8;
            content_by_lua_file lua/rpc_data_get.lua;
        }
}
```

## [conf.json](conf/conf.json)
