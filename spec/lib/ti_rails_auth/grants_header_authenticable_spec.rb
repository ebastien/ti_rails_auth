# encoding: utf-8

require 'ti_rails_auth'

describe TiRailsAuth::GrantsHeaderAuthenticable do

  before do
    @request = double(:request)
    allow(@request).to receive(:env).and_return(headers)

    @strategy = TiRailsAuth::GrantsHeaderAuthenticable.new(nil)
    allow(@strategy).to receive(:request).and_return(@request)

    @user = double(:user)
    allow(@user).to receive(:controls=) { |c| @controls = c }
    allow(@user).to receive(:preferences=) { |c| @preferences = c }

    @user_class = double(:user_class)
    allow(@user_class).to receive(:find_by_email).with('jon.snow@ti.com')
                                                 .and_return(@user)

    allow(TiRailsAuth::Config).to receive(:model).and_return(@user_class)
  end

  context "with valid trusted headers" do

    let!(:headers) do
      { 'HTTP_FROM' => 'jon.snow@ti.com',
        'HTTP_X_GRANTS' => Base64.encode64(ActiveSupport::JSON.encode({
          'grants' => [{
            'controls'      => { 'knows' => 'nothing' },
            'preferences' => { 'wear' => 'black' }
          }]
        })) }
    end

    it "authenticates" do
      expect(@strategy).to be_valid
      expect(@strategy.authenticate!).to eq(:success)
      expect(@controls).to eq({ 'knows' => 'nothing' })
      expect(@preferences).to eq({ 'wear' => 'black' })
    end
  end

  context "with invalid trusted headers" do

    let!(:headers) do
      { 'HTTP_FROM' => 'jon.snow@ti.com',
        'HTTP_X_GRANTS' => Base64.encode64("invalid grants") }
    end

    it "does not authenticate" do
      expect(@strategy).not_to be_valid
    end
  end
end
