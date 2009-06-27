$:.unshift File.dirname(__FILE__)

require 'socket'
require 'resolv'
require 'ipaddr'
require 'yaml'
require 'whois/server/server'

# Module for manage all Whois Class
module Whois

    # Base exception of Whois
    class WhoisException < Exception
    end

    # Exception of Whois who made report a bug
    class WhoisExceptionError < WhoisException
        def initialize (i)
            WhoisException.initialize("Report a bug with error #{i} to http://rubyforge.org/projects/whois/")
        end
    end

    # Class to get all information about Host or IP with the Whois request
    class Whois

        attr_reader :all
        attr_reader :server
        attr_reader :ip
        attr_reader :host
        attr_accessor :host_search

        # Initialize with a request. The request must be an IPv4, or a host string
        #
        # The first params now is :
        #  * a string which a Ipv4, Ipv6 or a host.
        #  * A IPAddr instance
        #
        # A second param, host_search is optionnal. By default he is false.
        # If this value is true, a resolv host is made for know the host to this IPv4
        def initialize(request, host_search=false)
            @host_search = host_search
            @host = nil
            if request.instance_of? IPAddr
                if request.ipv4?
                    @ip = request
                    @server = server_ipv4
                elsif request.ipv6?
                    @ip = request
                    @server = server_ipv6
                else
                    raise WhoisExceptionError.new(1)
                end
            elsif Resolv::IPv4::Regex =~ request
                ipv4_init request
                unless @server
                    raise WhoisException.new("no server found for this IPv4 : #{request}")
                end
            elsif Resolv::IPv6::Regex =~ request
                ipv6_init request
                unless @server
                    raise WhoisException.new("no server found for this Ipv6 : #{request}")
                end
            else
                # Test if the request is an host or not
                begin
                    ip = Resolv.getaddress request
                    @ip = IPAddr.new ip
                    @server = server_ipv4
                    @host = request
                rescue Resolv::ResolvError
                    raise WhoisException.new("host #{request} has no DNS result")
                end
            end
            
            search_host unless @host
        end
        
        # Ask of whois server
        def search_whois
            s = TCPsocket.open(@server.server, 43)
            s.write("#{self.ip.to_s}\n")
            ret = ''
            while s.gets do ret += $_ end
            s.close
            @all = ret
        end


        # Search the host for this IPv4, if the value host_search is true, else host = nil
        def search_host
            begin
                if @host_search
                    @host = Resolv.getname self.ip.to_s
                else
                    @host = nil
                end
            rescue Resolv::ResolvError
                @host = nil
            end
        end
    
    private
    
        # Init value for a ipv4 request
        def ipv4_init (ip)
            @ip = IPAddr.new ip
            @server = server_ipv4
        end

        # Init value for a ipv6 request
        def ipv6_init (ip)
            @ip = IPAddr.new ip
            @server = server_ipv6
        end

        # Return the Server with the hash of mask
        def server_with_hash(ip_hash)
          # Sort by mask of Ip Range
          arr_tmp = ip_hash.sort{|b,c| c[0][/\/(.+)/, 1].to_i <=> b[0][/\/(.+)/, 1].to_i}
          arr_tmp.each do |l|
            ip_range = IPAddr.new l[0]
            if ip_range.include? self.ip
              if l[1].nil? or l[1].empty?
                raise WhoisException.new("no server of Whois is define for the IP #{self.ip}. Sorry")
              end
              return Object.instance_eval("Server::#{l[1]}.new")
            end
          end
        end

        # Define the server of Whois in IPC6 list of YAML
        def server_ipv6
          ipv6_list = YAML::load_file(File.dirname(__FILE__) + '/whois/data/ipv6.yaml')
          server = server_with_hash(ipv6_list)
          unless server.kind_of? Server::Server
            raise WhoisException.new("no server found for this IPv6 : #{self.ip}")
          else
            return server
          end
        end
        
        # Define the server of Whois in IPV4 list of YAML
        def server_ipv4
          ipv4_list = YAML::load_file(File.dirname(__FILE__) + '/whois/data/ipv4.yaml')
          server = server_with_hash(ipv4_list)
          unless server.kind_of? Server::Server
            raise WhoisException.new("no server found for this IPv4 : #{self.ip}")
          else
            return server
          end
        end
    end
end


if $0 == __FILE__
  w = Whois::Whois.new '218.14.221.147'
  puts w.search_whois
end
