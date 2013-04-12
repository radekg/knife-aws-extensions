#
# Author:: Rad Gruchalski (<radek@gruchalski.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife/route53_base'

class Chef
  class Knife
    class Route53ZoneCreate < Knife

      include Knife::Route53Base

      banner "knife route53 zone create (options)"

      option :domain,
        :short => "-D DOMAIN",
        :long => "--domain",
        :description => "Domain name"
      
      option :description,
        :short => "-C COMMENT",
        :long => "--comment",
        :description => "Hosted zone comment"
        
      option :caller_reference,
        :short => "-R REFERENCE",
        :long => "--caller-ref",
        :description => "Hosted zone caller reference"

      def run
        
        validate!
        
        if config[:domain]
          
          ui.info "Creating hosted zone for domain: #{config[:domain]}"
          begin
            zone = connection.zones.create(
              :domain => config[:domain],
              :description => (config[:description] ? config[:description] : config[:domain]),
              :caller_reference => config[:caller_reference] )
            ui.info "Zone #{zone.id.to_s} for domain name #{config[:domain]} created."
          rescue Exception => e
            if config[:verbosity] == 2
              ui.error "Error while creating a hosted zone:"
              puts e.to_s
            else
              ui.error "Error while creating a hosted zone: #{e.response.status}. Rerun with -VV to see the error."
            end
          end
          
        else
          ui.error "No domain name given."
          exit 1
        end
        
      end
    end
  end
end
