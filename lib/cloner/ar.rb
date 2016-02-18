module Cloner::AR
  extend ActiveSupport::Concern

  def ar_conf
    @conf ||= begin
      YAML.load_file(Rails.root.join('config', 'database.yml'))[Rails.env]
    end
  end

  def ar_to
    ar_conf['database']
  end

  def ar_r_conf
    @ar_r_conf ||= begin
      do_ssh do |ssh|
        ret = ssh_exec!(ssh, "cat #{e(remote_app_path + '/config/database.yml')}")
        check_ssh_err(ret)
        begin
          res = YAML.load(ret[0])[env_from]
          raise 'no data' if res.blank?
          res['host'] ||= '127.0.0.1'
        rescue Exception => e
          puts "unable to read remote database.yml for env #{env_from}."
          puts "Remote file contents:"
          puts ret[0]
        end
        res
      end
    end
  end
end
