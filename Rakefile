require 'bundler/setup'
require 'rspec/core/rake_task'
require 'fileutils'

DISTRIBUTIONS = [
  { rb_platform: 'x86_64-darwin', tuple: %w(darwin amd64) },
  { rb_platform: 'arm64-darwin',  tuple: %w(darwin arm64) },
  { rb_platform: 'x86-linux',     tuple: %w(linux 386) },
  { rb_platform: 'x86_64-linux',  tuple: %w(linux amd64) },
  { rb_platform: 'arm-linux',     tuple: %w(linux arm) },
  { rb_platform: 'arm64-linux',   tuple: %w(linux arm64) },
  { rb_platform: 'aarch64-linux', tuple: %w(linux arm64) },
  { rb_platform: 'ppc64le-linux', tuple: %w(linux ppc64le) },
  { rb_platform: 's390x-linux',   tuple: %w(linux s390x) },
  { rb_platform: 'x86-mswin64',   tuple: %w(windows 386), ext: '.exe' },
  { rb_platform: 'x64-mswin64',   tuple: %w(windows amd64), ext: '.exe' }
]

task :build do
  require 'rubygems/package'
  require 'gke-auth-plugin-rb/version'

  FileUtils.mkdir_p('pkg')

  unless File.directory?('./tmp/gke-auth-plugin')
    system('git clone https://github.com/traviswt/gke-auth-plugin.git tmp/gke-auth-plugin/')
  end

  Dir.chdir('tmp/gke-auth-plugin') do
    system('git checkout dd706e7dc4c0ca6a5d7af982d7218a4c6372501e')
  end

  DISTRIBUTIONS.each do |distro|
    FileUtils.rm_rf('vendor')
    FileUtils.mkdir('vendor')

    Dir.chdir('./tmp/gke-auth-plugin') do
      system({ 'GOOS' => distro[:tuple][0], 'GOARCH' => distro[:tuple][1] }, 'make')
    end

    vendored_exe = "./vendor/gke-auth-plugin#{distro[:ext]}"
    FileUtils.cp('./tmp/gke-auth-plugin/bin/gke-auth-plugin', vendored_exe)

    # user rwx, group rx, world rxa
    File.chmod(0755, vendored_exe)

    gemspec = eval(File.read('gke-auth-plugin-rb.gemspec'))
    gemspec.platform = distro[:rb_platform]
    package = Gem::Package.build(gemspec)
    FileUtils.mv(package, 'pkg')
  end
end

task :publish do
  require 'kubectl-rb/version'
  require 'rotp'

  totp = ROTP::TOTP.new(ENV.fetch('TOTP_SECRET'), issuer: 'rubygems.org')

  Dir.glob(File.join('pkg', "kubectl-rb-#{KubectlRb::VERSION}-*.gem")).each do |pkg|
    puts "Publishing #{pkg}"
    system("gem push --otp #{totp.now} -k rubygems #{pkg}")
  end
end

task default: :spec

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.pattern = './spec/**/*_spec.rb'
end
