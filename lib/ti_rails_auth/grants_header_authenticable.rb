# encoding: utf-8
require 'warden'
require 'base64'
require 'multi_json'

module TiRailsAuth
  # Support for grants HTTP header authentication in Warden
  class GrantsHeaderAuthenticable < ::Warden::Strategies::Base

    attr_accessor :grants
    attr_accessor :email

    def valid?
      !authorization_header && email! && grants!
    end

    def authenticate!
      resource = email && Config.model.find_by_email(email)
      if resource
        if resource.respond_to? :controls=
          resource.controls = grants['controls']
        end
        success! resource
      else
        fail!
      end
    end

    private

    def grants_header
      request.env['HTTP_X_GRANTS']
    end

    def from_header
      request.env['HTTP_FROM']
    end

    def authorization_header
      request.env['HTTP_AUTHORIZATION']
    end

    def grants!
      self.grants ||= if grants_header
                        begin
                          MultiJson.load Base64.decode64(grants_header)
                        rescue MultiJson::LoadError
                          nil
                        end
                      end
    end

    def email!
      self.email ||= from_header
    end
  end
end
