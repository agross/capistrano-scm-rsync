require 'capistrano/scm/plugin'

module Capistrano
  class SCM
    class Rsync < ::Capistrano::SCM::Plugin
      def set_defaults
        set_if_empty :rsync_options,
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
      end

      def define_tasks
        eval_rakefile(File.expand_path('../tasks/rsync.rake', __FILE__))
      end

      def register_hooks
        after 'deploy:new_release_path', 'rsync:create_release'
        before 'deploy:set_current_revision', 'rsync:set_current_revision'
      end

      def copy_local_to_remote(role)
        if dry_run?
          puts "Would execute: #{rsync_command(role).inspect}"
          return
        end

        RakeFileUtils.sh(*rsync_command(role))
      end

      def create_release
        # Skip copying if we've already synced straight to the release directory.
        return unless remote_cache

        copy = [
          'rsync',
          fetch(:rsync_options)[:args][:cache_to_release],
          File.join(remote_directory, '/').shellescape,
          '.'
        ].flatten

        backend.execute(*copy)
      end

      private

      def rsync_command(role)
        rsync = %w(rsync) + fetch(:rsync_options)[:args][:local_to_remote]
        rsync << File.join(fetch(:rsync_options)[:source], '/')
        rsync << "#{remote_user(role)}#{role.hostname}:#{remote_directory}"
      end

      def remote_user(role)
        user = if role.user
                 role.user
               elsif fetch(:ssh_options)[:user]
                 fetch(:ssh_options)[:user]
               end

        "#{user}@" unless user.nil?
      end

      def remote_cache
        fetch(:rsync_options)[:cache]
      end

      def remote_directory
        return release_path unless remote_cache

        cache = remote_cache
        cache = File.join(shared_path, cache) if cache && cache !~ %r{^/}
        cache
      end
    end
  end
end
