describe Capistrano::SCM::Rsync do
  # This allows us to easily use `set`, `fetch`, etc. in the examples.
  let(:env) { Capistrano::Configuration.env }

  let(:remote_cache) { 'remote-cache' }
  let(:rsync_options) do
    {
      source: 'local-source',
      cache: remote_cache,
      args: {
        local_to_remote: %w(--local-to-remote),
        # ...copying the cache directory to the release_path.
        cache_to_release: %w(--cache-to-release)
      }
    }
  end

  before do
    env.set(:rsync_options, rsync_options)

    allow(subject).to receive(:puts)
    allow(subject).to receive(:shared_path).and_return('/shared/path')
    allow(subject).to receive(:release_path).and_return('/release/path')
  end

  describe '#copy_local_to_remote' do
    let(:dry_run?) { false }
    let(:role) { OpenStruct.new(user: 'user', hostname: 'server') }

    before do
      allow(subject).to receive(:dry_run?).and_return(dry_run?)
      allow(RakeFileUtils).to receive(:sh)

      subject.copy_local_to_remote(role)
    end

    context 'dry run' do
      let(:dry_run?) { true }

      it 'omits rsync' do
        expect(RakeFileUtils).not_to have_received(:sh)
      end
    end

    context 'using cache' do
      context 'relative to shared directory' do
        it 'rsyncs the local directory to the server cache' do
          args = %w(
            rsync
            --local-to-remote
            local-source/
            user@server:/shared/path/remote-cache
          )

          expect(RakeFileUtils).to have_received(:sh).with(*args)
        end
      end

      context 'absolute path' do
        let(:remote_cache) { '/absolute/remote-cache' }

        it 'rsyncs the local directory to the server cache' do
          args = %w(
            rsync
            --local-to-remote
            local-source/
            user@server:/absolute/remote-cache
          )

          expect(RakeFileUtils).to have_received(:sh).with(*args)
        end
      end
    end

    context 'not using cache' do
      let(:remote_cache) { nil }

      it 'rsyncs the local directory to the release path' do
        args = %w(
          rsync
          --local-to-remote
          local-source/
          user@server:/release/path
        )

        expect(RakeFileUtils).to have_received(:sh).with(*args)
      end
    end
  end

  describe '#create_release' do
    # Stub the SSHKit backend so we can set up expectations without the plugin
    # actually executing any commands.
    let(:backend) { spy }

    before do
      allow(SSHKit::Backend).to receive(:current).and_return(backend)

      subject.create_release
    end

    context 'using cache' do
      context 'relative to shared directory' do
        it 'rsyncs the server cache directory to the release path' do
          args = %w(
            rsync
            --cache-to-release
            /shared/path/remote-cache/
            .
          )

          expect(backend).to have_received(:execute).with(*args)
        end
      end

      context 'absolute path' do
        let(:remote_cache) { '/absolute/remote-cache' }

        it 'rsyncs the local directory to the server cache' do
          args = %w(
            rsync
            --cache-to-release
            /absolute/remote-cache/
            .
          )

          expect(backend).to have_received(:execute).with(*args)
        end
      end
    end

    context 'not using cache' do
      let(:remote_cache) { nil }

      it 'is a no-op' do
        expect(backend).not_to have_received(:execute)
      end
    end
  end
end
