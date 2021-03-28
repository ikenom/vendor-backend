class RedisUriBuilder
  def self.build
    "redis://#{ENV["RELEASE_NAME"]}-redis-master.default.svc.cluster.local"
  end
end