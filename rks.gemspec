
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rks/version"

Gem::Specification.new do |spec|
  spec.name          = "rks"
  spec.version       = RKS::VERSION
  spec.authors       = ["Sittitep Tosuwan"]
  spec.email         = ["sittitep.tosuwan@gmail.com"]

  spec.summary       = "Ruby Kafka Sidekiq"
  spec.description   = "Ruby Kafka Sidekiq"
  spec.homepage      = "http://not.now"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.26"
  spec.add_development_dependency "rake", "~> 13.0.6"
  
  spec.add_dependency "avro_turf", "~> 0.8.1"
  spec.add_dependency "byebug", "~> 10.0.2"
  spec.add_dependency "concurrent-ruby", "~> 1.1.3"
  spec.add_dependency "logstash-logger", "~> 0.26.1"
  spec.add_dependency "minitest", "~> 5.11.3"
  spec.add_dependency "poseidon", "~> 0.0.5"
  spec.add_dependency "ruby-kafka", "~> 0.7.4"
  spec.add_dependency "sidekiq", "~> 6.2.2"
  spec.add_dependency "rack", "~> 2.2.2"
  spec.add_dependency "puma", ">= 5.4", "< 5.6"

  spec.add_runtime_dependency "thor"
end
