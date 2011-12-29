#
# Author:: John Goulah (<jgoulah@gmail.com>)
# Copyright:: Copyright (c) 2011 John Goulah
#
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
#

module GoulahKnifePlugins
  class Crawl < Chef::Knife

    banner "knife crawl ROLE"

    def initialize(*args)
      @level = 0
      super
    end


    deps do
      require 'chef/role'
      require 'chef/search/query'
    end

    option :included,
      :short => '-i',
      :long => '--included',
      :boolean => true,
      :default => false,
      :description => "Find the roles this role is included in"

    def run
      unless name_args.size == 1
        puts "You need to supply a role"
        show_usage
        exit 1
      end

      if config[:verbosity] == 1
        @verbose = true
      end

      role_name = name_args.first

      output "\n#{role_name} child hierarchy:"
      output " * " + role_name
      crawl_role(role_name)

      if config[:included]
        output "\n#{role_name} is included in the following roles:"
        included_from(role_name)
      end
    end

    def included_from(role_name)
        @level = @level + 1
        q_roles = Chef::Search::Query.new
        query = "run_list:role\\[#{role_name}\\]"

        result_items_nodes = []
        result_count_nodes = 0

        begin
          result = q_roles.search('role', query, nil, 0, 1000)
          if result[2] == 0
            output "none"
          end
          result[0].each do |role|
            output " * " + role.name
          end
        rescue Net::HTTPServerException => e
          msg = Chef::JSONCompat.from_json(e.response.body)["error"].first
          ui.error("knife crawl failed: #{msg}")
          exit 1
        end

    end

    def crawl_role(role_name)
      @level = @level + 1
      role = Chef::Role.load(role_name)

      if !has_roles? role and @verbose
        output " - no further roles found under " + role_name
      end

      role.run_list.each do |item|
        if item.role?
          output " * " + item.name
          crawl_role(item.name)
        end
      end

      @level = @level - 1
    end

    def output(msg)
      ui.msg(indent_str + msg)
    end

    def indent_str
        str = ""
        level = @level
        while level > 0
          str << "  "
          level -= 1
        end
        return str
    end

    # search the run_list for roles (since it has roles and recipes)
    def has_roles?(role)
      role.run_list.each do |item|
        if item.role?
            return true
        end
      end
      return false
    end

  end
end
