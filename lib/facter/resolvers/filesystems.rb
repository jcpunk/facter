# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Filesystems < BaseResolver
        # :systems

        init_resolver

        class << self
          private

          def post_resolve(fact_name, _options)
            @fact_list.fetch(fact_name) { read_filesystems(fact_name) }
          end

          def read_filesystems(fact_name)
            output = Facter::Util::FileHelper.safe_readlines('/proc/filesystems', nil)
            return unless output

            filesystems = []
            output.each do |line|
              tokens = line.split(' ')
              filesystems << tokens if tokens.size == 1 && tokens.first != 'fuseblk'
            end
            @fact_list[:systems] = filesystems.sort.join(',')
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
