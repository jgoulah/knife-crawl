# knife-crawl

A plugin for Chef::Knife which displays the roles that are included recursively within a role and optionally displays all the roles that include it.

## Usage 

Supply a role name to get a dump of its hierarchy, pass -i for the roles that also include it

```
% knife crawl VMDevStack -i                                                                                                                         ✹

VMDevStack child hierarchy:
 * VMDevStack
   * SharedDevStack

VMDevStack is included in the following roles:
   * VMBase
```

## Installation

#### Script install

Copy the knife-crawl script from lib/chef/knife/crawl.rb to your ~/.chef/plugins/knife directory.

#### Gem install

knife-crawl is available on rubygems.org - if you have that source in your gemrc, you can simply use:

    gem install knife-crawl
