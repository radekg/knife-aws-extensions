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
    class Route53ZoneRecordChange < Knife

      include Knife::Route53Base

      banner "knife route53 zone record change (options)"
      
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

      option :value,
        :short => "-N NAME",
        :long => "--name",
        :description => "Record set name"
      
      # Changeable options:

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
        :short => "-V TTL",
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
        :description => "Routing policy weight"
      
      # Routing Policy:
      # Weighted: Weight and Set ID
      # Latency:  Region and Set ID
      # Failover: Set ID
      
    end
  end
end