module Cloner::Internal
  extend ActiveSupport::Concern
  include Cloner::MongoDB
  include Cloner::Postgres
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

  def db_restore_options
  end

  def clone_db
    if defined?(Mongoid)
      clone_mongodb
    else
      clone_pg
    end
  end
end

