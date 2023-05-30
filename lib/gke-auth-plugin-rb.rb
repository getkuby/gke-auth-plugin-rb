module GKEAuthPluginRb
  def self.executable
    @executable ||= begin
      pattern = File.expand_path(File.join('..', 'vendor', 'gke-auth-plugin*'), __dir__)
      Dir.glob(pattern).first
    end
  end
end
