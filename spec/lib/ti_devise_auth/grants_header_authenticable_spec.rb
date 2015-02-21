# encoding: utf-8

require 'ti_devise_auth'

describe TiDeviseAuth::GrantsHeaderAuthenticable do

  before do
    @request = double(:request)
    allow(@request).to receive(:headers).and_return(headers)

    @strategy = TiDeviseAuth::GrantsHeaderAuthenticable.new(nil)
    allow(@strategy).to receive(:request).and_return(@request)

    @user = double(:user)
    allow(@user).to receive(:grants=) { |grants| @grants = grants }

    @user_class = double(:user_class)
    allow(@user_class).to receive(:find_by_email).with('jon.snow@ti.com')
                                                 .and_return(@user)

    @mapping = double(:mapping)
    allow(@mapping).to receive(:to).and_return(@user_class)

    allow(@strategy).to receive(:mapping).and_return(@mapping)
  end

  context "with valid trusted headers" do

    let!(:headers) do
      { 'From' => 'jon.snow@ti.com',
        'X-Grants' => Base64.encode64(MultiJson.dump({
          'knows' => 'nothing'
        })) }
    end

    it "authenticates" do
      expect(@strategy).to be_valid
      expect(@strategy.authenticate!).to eq(:success)
      expect(@grants).to eq({ 'knows' => 'nothing' })
    end
  end

  context "with invalid trusted headers" do

    let!(:headers) do
      { 'From' => 'jon.snow@ti.com',
        'X-Grants' => Base64.encode64("invalid grants") }
    end

    it "does not authenticate" do
      expect(@strategy).not_to be_valid
    end
  end
end
