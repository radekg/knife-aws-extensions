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
    class Route53ZoneDelete < Knife

      include Knife::Route53Base

      banner "knife route53 zone delete (options)"
      
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
        
        confirm("Are you sure you want to remove hosted zone #{zone.id.to_s} (#{zone.domain.to_s}) that contains #{zone.records.all!.count} records")
        zone.destroy
        ui.info "Hosted zone #{zone.id.to_s} for domain name #{zone.domain.to_s} deleted."
        
      end
    end
  end
end
