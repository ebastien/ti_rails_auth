# encoding: utf-8
require 'active_support/concern'

module TiDeviseAuth
  module Controller
    extend ActiveSupport::Concern

    def warden
      request.env['warden']
    end

    def warden_scope
      Rails.application.config.ti_devise_auth.scope
    end

    def current_user
      warden && warden.user(warden_scope)
    end

    def authenticate
      warden && warden.authenticate(scope: warden_scope)
    end

    def invalid_credentials
      render json: {}, status: 401
    end

    module ClassMethods
      def ensure_signed_in
        before_filter { invalid_credentials unless authenticate }
      end
    end
  end
end
