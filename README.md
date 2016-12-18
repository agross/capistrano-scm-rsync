# Capistrano::SCM::Rsync

[![Gem Version](https://badge.fury.io/rb/capistrano-scm-rsync.svg)](http://badge.fury.io/rb/capistrano-scm-rsync)
[![Build Status](https://travis-ci.org/agross/capistrano-scm-rsync.png?branch=master)](https://travis-ci.org/agross/capistrano-scm-rsync)
[![Dependency Status](https://gemnasium.com/agross/capistrano-scm-rsync.svg)](https://gemnasium.com/agross/capistrano-scm-rsync)
[![Code Climate](https://codeclimate.com/github/agross/capistrano-scm-rsync.png)](https://codeclimate.com/github/agross/capistrano-scm-rsync)
[![Coverage Status](https://coveralls.io/repos/agross/capistrano-scm-rsync/badge.svg)](https://coveralls.io/r/agross/capistrano-scm-rsync)

`capistrano-scm-rsync` allows you to use rsync to deploy your application to your servers.

* Tested against Ruby 2.x
* Ruby < 2.0 is not supported

## Installation

Add it to your `Gemfile`:

```ruby
gem 'capistrano-scm-rsync'
```

```sh
$ bundle install
```

Use the plugin with capistrano by adding it to your `Capfile`:

```ruby
require 'capistrano/scm/rsync'
install_plugin Capistrano::SCM::Rsync
```

## Configuration

In your `config/deploy.rb`:

```ruby
set :rsync_options,
    # The local directory to be copied to the server.
    source: 'app',
    # The cache directory on the server that receives files
    # from the source directory. Relative to shared_path or
    # an absolute path.
    # Saves you rsyncing your whole app folder each time. If
    # set to nil Capistrano::SCM::Rsync will sync directly to
    # the release_path.
    cache: 'cache',
    # Arguments passed to rsync when...
    args: {
      # ...copying the local directory to the server.
      local_to_remote: [],
      # ...copying the cache directory to the release_path.
      cache_to_release: %w(--archive --acls --xattrs)
    }
```

## Example

See https://github.com/dnugleipzig/deploy.

## Development

* Source hosted at [GitHub](https://github.com/agross/capistrano-scm-rsync)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/agross/capistrano-scm-rsync/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change you make.

## Contributing

1. Fork it http://github.com/agross/capistrano-scm-rsync/fork
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
