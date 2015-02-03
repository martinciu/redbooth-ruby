require "spec_helper"

describe RedboothRuby::Session do
  include_context 'authentication'
  let(:token) { access_token[:token] }
  let(:refresh_token) { access_token[:refresh_token] }

  describe 'initialize' do
    subject { described_class.new(access_token) }

    it { expect(subject.refresh_token).to eq refresh_token }
  end

  describe '#refresh' do
    subject { described_class.new(access_token).refresh! }

    context 'refresh token present' do
      let(:oauth_client) { double(:oauth_client) }
      let(:oauth_access_token) { double(:access_token, refresh!: new_oauth_access_token) }
      let(:new_oauth_access_token) { double(:access_token, token: 'new_token', refresh_token: 'new_refresh_token' ) }

      before do
        allow(OAuth2::Client).to receive(:new).with(consumer_key, consumer_secret, described_class::OAUTH_URLS).and_return(oauth_client)
        allow(OAuth2::AccessToken).to receive(:new).with(oauth_client, token, { refresh_token: refresh_token }).and_return(oauth_access_token)
      end

      it { expect(subject).to eq new_oauth_access_token }
      it do
        expect(oauth_access_token).to receive(:refresh!)
        subject
      end
    end
  end
end
