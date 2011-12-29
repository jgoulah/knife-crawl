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

Drop into your ~/.chef/plugins/knife/ dir
