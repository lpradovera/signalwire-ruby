# frozen_string_literal: true

module Twilio
  module REST
    class Fax < Domain
      def initialize(twilio)
        super

        @host = ENV['SIGNALWIRE_SPACE_URL'] || Signalwire::Sdk.configuration.hostname || raise(ArgumentError,
          'SignalWire Space URL is not configured. Enter your SignalWire Space domain via the '\
          'SIGNALWIRE_SPACE_URL environment variable, or hostname in the configuration.')
        @base_url = "https://#{@host}/api/laml"
        @port = 443

        # Versions
        @v1= nil

        # New properties
        @account_sid = twilio.account_sid
      end

      def hostname
        @host
      end

      def account_sid
        @account_sid
      end

      class V1 < Version
        def initialize(domain)
          super
          @version = "2010-04-01/Accounts/#{domain.account_sid}"
          @faxes = nil
        end

        class FaxList < ListResource
          def initialize(version)
            super(version)

            @solution = {}
            @uri = "/Faxes.json"
          end
        end

        class FaxContext < InstanceContext
          def initialize(version, sid)
            super(version)

            @solution = { sid: sid }
            @uri = "/Faxes/#{@solution[:sid]}.json"

            @media = nil
          end
        end
      end
    end
  end
end
