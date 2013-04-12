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
    class Route53ZoneRecordCreate < Knife

      include Knife::Route53Base

      banner "knife route53 zone record create (options)"
      
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

      option :ttl,
        :short => "-L TTL",
        :long => "--ttl",
        :type => Fixnum,
        :description => "TTL for the record",
        :default => 300

      option :value,
        :short => "-B VALUE",
        :long => "--value",
        :description => "Record value"

      option :alias, # only for record types A and AAAA
        :short => "-A ALIAS",
        :long => "--alias",
        :description => "Alias target"

      option :set_id,
        :short => "-G REGION",
        :long => "--region",
        :description => "Routing policy: region"
      
      option :set_id,
        :short => "-S SETID",
        :long => "--set-id",
        :description => "Routing policy set ID"
        
      option :weight,
        :short => "-W WEIGHT",
        :long => "--weight",
        :type => Fixnum,
        :description => "Routing policy weight",
        :default => 0
      
      # Routing Policy:
      # Weighted: Weight and Set ID
      # Latency:  Region and Set ID
      # Failover: Set ID
      
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
        
        if not config[:name].end_with?( zone.domain.to_s )
          config[:name] = "#{config[:name]}.#{zone.domain.to_s}"
        end
        
        begin
          record = zone.records.create(
            :name => config[:name],
            :value => config[:value].split(","),
            :ttl => config[:ttl],
            :type => config[:type],
            :alias_target => config[:alias],
            :region => config[:region],
            :weight => config[:weight],
            :set_identifier => config[:set_identifier]
          )
        
          ui.info "Record #{record.name.to_s} of type #{record.type.to_s} created."
        rescue Exception => e
          if config[:verbosity] == 2
            ui.error "Error while creating a record:"
            puts e.to_s
          else
            ui.error "Error while creating a record: #{e.response.status}. Rerun with -VV to see the error."
          end
        end
        
      end
      
      def validate!
        super
        
        record_types = ["A", "CNAME", "MX", "AAAA", "TXT", "PTR", "SRV", "SPF", "NS"]
        
        if not record_types.include?(config[:type])
          ui.error "Unknown record type: #{config[:type]}"
          exit 1
        end
        
        if config[:alias]
          if not ["A", "AAAA"].include?(config[:type])
            ui.error "Only record type A or AAAA is allowed when aliasing."
            exit 1
          end
          
        end
        
      end
      
    end
  end
end