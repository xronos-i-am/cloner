module Cloner::Internal
  extend ActiveSupport::Concern
  include Cloner::MongoDB
  include Cloner::Ar
  include Cloner::Postgres
  include Cloner::Mysql
  include Cloner::SSH
  include Cloner::RSync

  def e(str)
    Shellwords.escape(str)
  end

  def load_env
    unless defined?(Rails)
      require rails_path
    end
    require 'net/ssh'
  end

  def verbose?
    false
  end
  def env_from
    ENV['CLONE_FROM'] || 'production'
  end

  def clone_db
    if defined?(Mongoid)
      clone_mongodb
    elsif defined?(PG)
      clone_pg
    else
      clone_mysql
    end
  end
end

