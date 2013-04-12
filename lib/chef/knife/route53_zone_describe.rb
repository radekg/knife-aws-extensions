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
    class Route53ZoneDescribe < Knife

      include Knife::Route53Base

      banner "knife route53 zone describe (options)"
      
      option :zone_id,
        :short => "-Z ZONEID",
        :long => "--zone-id",
        :description => "Hosted zone ID"
      
      option :domain,
        :short => "-D DOMAIN",
        :long => "--domain",
        :description => "Domain name"
        
      option :caller_reference,
        :short => "-R REFERENCE",
        :long => "--caller-ref",
        :description => "Hosted zone caller reference"
      
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
        
        zone = connection.zones.get( zone.id.to_s )
        
        msg_pair("Zone ID", zone.id.to_s)
        msg_pair("Domain", zone.domain.to_s)
        msg_pair("Caller reference", zone.caller_reference.to_s)
        msg_pair("Change info", zone.change_info.to_s)
        msg_pair("Description", zone.description.to_s)
        msg_pair("Nameservers", zone.nameservers.join(","))
        
        puts "\nRecords:\n"
        
        record_list = [
          ui.color('ID', :bold),
          ui.color('Name', :bold),
          ui.color('Type', :bold),
          ui.color('Value', :bold),
          ui.color('TTL', :bold),
          ui.color('Status', :bold),
          ui.color('Alias target', :bold),
          ui.color('Region', :bold),
          ui.color('Weight', :bold),
          ui.color('Set identifier', :bold),
        ].flatten.compact
        
        output_column_count = record_list.length
        
        zone.records.all!.each do |record|
          
          counter = 1
          record.value.each do |value|
            record_list << (counter == 1 ? record.change_id.to_s : " ")
            record_list << (counter == 1 ? record.name.to_s : " ")
            record_list << (counter == 1 ? record.type.to_s : " ")
            if value.length > 47
              record_list << "#{value[0 .. 47]}..."
            else
              record_list << value
            end
            record_list << (counter == 1 ? record.ttl.to_s : " ")
            record_list << (counter == 1 ? record.status.to_s : " ")
            record_list << (counter == 1 ? record.alias_target.to_s : " ")
            record_list << (counter == 1 ? record.region.to_s : " ")
            record_list << (counter == 1 ? record.weight.to_s : " ")
            record_list << (counter == 1 ? record.set_identifier.to_s : " ")
            counter = counter + 1
          end
        end
        
        puts ui.list(record_list, :uneven_columns_across, output_column_count)
        puts "\n"
        
      end
    end
  end
end
