# frozen_string_literal: true

module Facter
  module Resolvers
    class DMIBios < BaseResolver
      init_resolver

      class << self
        # Manufacturer
        # SerialNumber

        private

        def post_resolve(fact_name, _options)
          @fact_list.fetch(fact_name) { read_fact_from_bios(fact_name) }
        end

        def read_fact_from_bios(fact_name)
          win = Facter::Util::Windows::Win32Ole.new

          bios = win.return_first('SELECT Manufacturer,SerialNumber from Win32_BIOS')
          unless bios
            @log.debug 'WMI query returned no results for Win32_BIOS with values Manufacturer and SerialNumber.'
            return
          end

          build_fact_list(bios)

          @fact_list[fact_name]
        end

        def build_fact_list(bios)
          @fact_list[:manufacturer] = bios.Manufacturer
          @fact_list[:serial_number] = bios.SerialNumber
        end
      end
    end
  end
end
