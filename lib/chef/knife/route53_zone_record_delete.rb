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
    class Route53ZoneRecordDelete < Knife

      include Knife::Route53Base

      banner "knife route53 zone record delete (options)"
      
      option :description,
        :short => "-Z ZONEID",
        :long => "--zone-id",
        :description => "Hosted zone comment"

      option :domain,
        :short => "-D DOMAIN",
        :long => "--domain",
        :description => "Domain name"

      option :caller_reference,
        :short => "-R REFERENCE",
        :long => "--caller-ref",
        :description => "Hosted zone caller reference"

      option :name,
        :short => "-N NAME",
        :long => "--name",
        :description => "Record set name"

      option :type,
        :short => "-T TYPE",
        :long => "--type",
        :description => "Record type: A, CNAME, MX, AAAA, TXT, PTR, SRV, SPF, NS",
        :default => "A"
      
      def run
        
        validate!
        
        element = get_element
        
        if element.nil?
          ui.error "No zone id / domain name / caller reference specified."
          exit 1
        end
        
        zone = zone_by_element( element )
        
        if zone.nil?
          ui.error "Could not match element #{element} to any existing hosted zone."
          exit 1
        end
        
        if config[:name] && config[:type]
          
          record = zone.records.get(config[:name], config[:type])
          
          if record.nil?
            record = zone.records.get("#{config[:name]}.#{zone.domain.to_s}", config[:type])
          end
          
          if record.nil?
            ui.error "Record #{config[:name]} of type #{config[:type]} not found."
            exit 1
          else
            confirm("Are you sure you want to remove record #{record.name} of type #{record.type}")
            record.destroy
            ui.info "Record deleted."
          end
        else
          ui.error "Name and type of the record are required when removing records."
          exit 1
        end
        
      end
      
      def validate!
        super
        
        record_types = ["A", "CNAME", "MX", "AAAA", "TXT", "PTR", "SRV", "SPF", "NS"]
        
        if not record_types.include?(config[:type])
          ui.error "Unknown record type: #{config[:type]}"
          exit 1
        end
        
      end
      
    end
  end
end