# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/sms/infobip/version"

Gem::Specification.new do |s|
  s.version = Decidim::Sms::Infobip.version
  s.authors = ["Digidem Lab"]
  s.email = ["rupus@digidemlab.org"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/digidemlab/decidim-sms-infobip"
  s.required_ruby_version = ">= 3.1"

  s.name = "decidim-sms-infobip"
  s.summary = "A decidim sms-infobip module"
  s.description = "Infobip SMS provider integration."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Sms::Infobip.decidim_version
  s.add_dependency "infobip-sms", "~> 0.1.3"
  s.metadata["rubygems_mfa_required"] = "true"
end
