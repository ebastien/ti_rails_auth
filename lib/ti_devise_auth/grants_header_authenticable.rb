# encoding: utf-8

require 'multi_json'

# Support for grants HTTP header authentication in Devise
class TiDeviseAuth::GrantsHeaderAuthenticable < ::Devise::Strategies::Base

  attr_accessor :grants
  attr_accessor :email

  def valid?
    !authorization_header && email! && grants!
  end

  def authenticate!
    resource = email && mapping.to.find_by_email(email)
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
    request.headers['X-Grants']
  end

  def from_header
    request.headers['From']
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
    self.email ||= from_header.presence
  end

  def authorization_header
    request.headers['Authorization']
  end
end
