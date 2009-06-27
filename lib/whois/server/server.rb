module Whois
  module Server

    # Define if the module has or not the Class in this module
    def self.class_exist? str
        begin
            self.class_eval str.to_s
            return true
        rescue NameError
            return false
        end
    end

    # Class For define a model of Server
    class Server
        attr_reader :server
    end
    
    # Class for the server Afrinic
    class Afrinic < Server
    
        def initialize
            @server = 'whois.afrinic.net'
        end
    end

    # Class for the Server Apnic
    class Apnic < Server

        def initialize
            @server = 'whois.apnic.net'
        end
    end

    # Class for the Server Ripe
    class Ripe < Server
        def initialize
            @server = 'whois.ripe.net'
        end
    end

    # Class for the Server Arin
    class Arin < Server
        def initialize
            @server = 'whois.arin.net'
        end
    end

    # Class for the Server Lacnic
    class Lacnic < Server
        def initialize
            @server = 'whois.lacnic.net'
        end
    end

    # Class for Server whois.nic.or.kr
    class Nicor < Server
        def initialize
            @server = 'whois.nic.or.kr'
        end
    end
    
    # Class for Server whois.nic.ad.jp
    class Nicad < Server
        def initialize
            @server = 'whois.nic.ad.jp'
        end
    end

    # Class for Server whois.nic.br
    class Nicbr < Server
        def initialize
            @server = 'whois.nic.br'
        end
    end

    # Class for the teredo RFC 4773 
    class Teredo < Server
        def initialize
            @server = nil
        end
    end

    # Class for 6To4 RFC 3056
    class Ipv6ToIpv4 < Server
        def initialize
             @server = nil
         end
    end

    # Class for server whois.v6nic.net
    class V6nic < Server
        def initialize
             @server = 'whois.v6nic.net'
         end
    end

    # Class for server whois.twnic.net
    class Twnic < Server
        def initialize
            @server = 'whois.twnic.net'
        end
    end

    # Class for server whois.verio.net
    class Verio < Server
        def initialize
            @server = 'whois.verio.net'
        end
    end

    # Class for server whois.6bone.net
    class Ipv6Bone < Server
        def initialize
            @server = 'whois.6bone.net'
        end
    end

    class Ginntt < Server
      def initialize
        @server = 'rwhois.gin.ntt.net'
      end
    end
  end    
end
