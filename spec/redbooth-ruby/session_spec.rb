require "spec_helper"

describe RedboothRuby::Session do
  include_context 'authentication'

  describe 'initialize' do
    subject { described_class.new(access_token) }

    it { expect(subject.refresh_token).to eq access_token[:refresh_token] }
  end

  describe '#refresh', vcr: 'refresh_token' do
    subject { described_class.new(access_token).refresh! }

    context 'refresh token present' do
      it { expect(subject.refresh_token).to eq 'new_refresh_token_token' }
    end

    context 'refresh token not present' do
      before do
        access_token.delete(:refresh_token)
      end

      it { expect { subject }.to raise_exception }
    end
  end
end
