$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ti_devise_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ti_devise_auth"
  s.version     = TiDeviseAuth::VERSION
  s.authors     = ["Emmanuel Bastien"]
  s.email       = ["os@ebastien.name"]
  s.homepage    = "https://github.com/opentraveldata"
  s.summary     = "Trusted header Devise plugin."
  s.description = "TiDeviseAuth manages authentication and authorization from trusted HTTP headers."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "warden"
  s.add_dependency "multi_json"

  s.add_development_dependency "rspec-rails"
end
