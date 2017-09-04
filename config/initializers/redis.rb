redis_settings = APP_CONFIG['redis']
redis_settings['port'] ||= 6379

$redis = Redis.new redis_settings