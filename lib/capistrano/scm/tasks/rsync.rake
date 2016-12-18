# This trick lets us access the Rsync plugin within `on` blocks.
rsync_plugin = self

namespace :rsync do
  desc 'Copy the local source directory to the remote cache or release directory'
  task :copy_local_to_remote do
    on release_roles(:all) do |role|
      rsync_plugin.copy_local_to_remote(role)
    end
  end

  desc 'Create new release'
  task create_release: [:copy_local_to_remote] do
    on release_roles(:all) do
      execute :mkdir, '-p', release_path

      within release_path do
        rsync_plugin.create_release
      end
    end
  end

  task :set_current_revision do
    set_if_empty :current_revision, now
  end
end
