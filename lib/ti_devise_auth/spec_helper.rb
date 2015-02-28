# encoding: utf-8

module TiDeviseAuth
  module SpecHelper
    def sign_in(user)
      allow(controller).to receive(:authenticate).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
