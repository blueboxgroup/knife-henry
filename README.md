# knife-henry

A knife plugin to speed-up the creation of chef-solo repositories

A simple blueprint like this:

```text
--- 
name: HenryCorp
roles:
 - bastion:
    - base 
 - app:
    - base
    - nginx
    - unicorn
    - ruby
    - nodejs
    - postgresql-client
 - db:
    - base
    - postgresql-server
 - cache:
    - base
    - memcache
 - redis:
    - base
    - redis-server
 - worker:
    - base
    - ruby
    - postgresql-client
vars:
  ruby:
    version: 2.1.1
```

generates a chef-solo repository like this:

```text
HenryCorp
|-- Berksfile
|-- CHANGELOG.txt
|-- cookbooks
|-- data_bags
|-- environments
|-- Gemfile
|-- nodes
|-- README.md
|-- roles
|   |-- app.rb
|   |-- base.rb
|   |-- bastion.rb
|   |-- cache.rb
|   |-- db.rb
|   |-- memcache.rb
|   |-- nginx.rb
|   |-- nodejs.rb
|   |-- postgresql-client.rb
|   |-- postgresql-server.rb
|   |-- redis.rb
|   |-- redis-server.rb
|   |-- ruby.rb
|   |-- unicorn.rb
|   `-- worker.rb
`-- site-cookbooks
    `-- HenryCorp
        |-- attributes
        |   `-- default.rb
        |-- CHANGELOG.md
        |-- definitions
        |-- files
        |   `-- default
        |-- libraries
        |-- metadata.rb
        |-- providers
        |-- README.md
        |-- recipes
        |   |-- base.rb
        |   |-- default.rb
        |   |-- memcache.rb
        |   |-- nginx.rb
        |   |-- redis-server.rb
        |   `-- unicorn.rb
        |-- resources
        `-- templates
            `-- default
                |-- nginx.conf.erb
                `-- unicorn.conf.erb

```

## Installation

```text
gem "knife-henry", :git => "git://github.com/blueboxgroup/knife-henry.git"
```

or

```bash
git clone git@github.blueboxgrid.com:bluebox-tech/knife-henry.git
cd knife-henry
rake install
```

## Using knife-henry

### Creating a blueprint

knife-henry comes with a default blueprint and sample components to help jump-start new projects.

```bash
knife henry blueprint create HenryCorp
```

Edit the resultant yaml file to specify the node's roles, role components, and any component variables.

### Building a repository

To build the new repository from the blueprint, kick off the factory with:

```bash
knife henry repo build HenryCorp.yml
```

### Adding/Overriding components

To add a new component, build out a YAML file and add it to the user library with:

```bash
knife henry component load COMPONENT.yml
```

New components will override built-in components with the same name.
