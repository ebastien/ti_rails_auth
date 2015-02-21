# encoding: utf-8

require 'devise'
require 'ti_devise_auth/grants_header_authenticable'

module TiDeviseAuth
  class Railtie < Rails::Railtie
    
    config.ti_devise_auth = ActiveSupport::OrderedOptions.new
    config.ti_devise_auth.scope = :user

    config.after_initialize do
      Devise.warden_config.strategies.add :grants_header_authenticable,
                                          GrantsHeaderAuthenticable
      Devise.warden_config.scope_defaults config.ti_devise_auth.scope,
                                          store: false,
                                          strategies: [
                                            :grants_header_authenticable 
                                          ]
    end
  end
end
