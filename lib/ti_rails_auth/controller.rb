# encoding: utf-8
require 'active_support/concern'

module TiRailsAuth
  module Controller
    extend ActiveSupport::Concern

    def warden
      request.env['warden']
    end

    def current_user
      warden && warden.user(Config.scope)
    end

    def authenticate
      warden && warden.authenticate(TiRailsAuth::STRATEGY, scope: Config.scope)
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
