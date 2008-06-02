class Typo3
  attr_reader :sitename,:username, :password, :host, :dbname, :install_password
  
  def initialize
    get_TYPO3_details
    
    # look at somehow making this more automatically specific to environment
    @port = 3306
    
    @socket = `locate -l 1 mysql.sock`.to_s.strip
  end
  
  def show_config
    config = %{
  TYPO3 Sitename: #{@sitename}
    DB Username: #{@username}
    DB Password: #{@password}
    DB Host: #{@host}
    DB Name: #{@dbname}
    Install Tool: #{@install_password}
  }

    print config
  end

  def with_db
    dbh = Mysql.real_connect(self.host,self.username,self.password,self.dbname,@port,@socket)

    begin
      yield dbh
    ensure
      dbh.close
    end
  end

  private
  def get_TYPO3_details
    localconf = FileList['**/localconf.php']

    localconf.each do |t|
        conf = IO.read(t)
        @sitename         = conf.scan(/\$TYPO3_CONF_VARS\[\'SYS\'\]\[\'sitename\'\]\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
        @username         = conf.scan(/\$typo_db_username\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
        @password         = conf.scan(/\$typo_db_password\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
        @host             = conf.scan(/\$typo_db_host\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
        @dbname           = conf.scan(/\$typo_db\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
        @install_password = conf.scan(/\$TYPO3_CONF_VARS\[\'BE\'\]\[\'installToolPassword\'\]\s+=\s+\'(.*)\'\;/).last.to_s ||= ''
    end
    
  end
end