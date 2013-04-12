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
    class Route53ZoneList < Knife

      include Knife::Route53Base

      banner "knife route53 zone list"
      
      option :nameservers,
        :short => "-N",
        :long => "--nameservers",
        :boolean => true,
        :default => false,
        :description => "Fetch nameservers for each hosted zone."

      def run
        
        $stdout.sync = true

        validate!

        zone_list = [
          ui.color('Zone ID', :bold),
          ui.color('Caller reference', :bold),
          ui.color('Change info', :bold),
          ui.color('Description', :bold),
          ui.color('Domain', :bold),
          if config[:nameservers]
            ui.color('Nameservers', :bold)
          end
        ].flatten.compact
        
        output_column_count = zone_list.length

        connection.zones.all.each do |zone|
          zone_list << zone.id.to_s
          zone_list << zone.caller_reference.to_s
          zone_list << zone.change_info.to_s
          zone_list << zone.description.to_s
          zone_list << zone.domain.to_s
          if config[:nameservers]
            zone_list << connection.zones.get( zone.id ).nameservers.join(",")
          end
        end
        
        puts ui.list(zone_list, :uneven_columns_across, output_column_count)
        
      end
    end
  end
end
