require 'spec_helper'

describe Nvlope do

  subject{ nvlope }

  let :nvlope do
    described_class.new(config)
  end

  def config
    {
      # grant_type:    grant_type,
      username:      username,
      password:      password,
      client_id:     client_id,
      client_secret: client_secret,
      # domain:        domain,
    }
  end

  # let(:grant_type)   { 'password' }
  let(:username)     { 'Newman' }
  let(:password)     { 'lostinthemail' }
  let(:client_id)    { 'FAKE_CLIENT_ID' }
  let(:client_secret){ 'FAKE_CLIENT_SECRET' }
  # let(:domain)       {  }

  its(:username)     { should eq 'Newman' }
  its(:password)     { should eq 'lostinthemail' }
  its(:client_id)    { should eq 'FAKE_CLIENT_ID' }
  its(:client_secret){ should eq 'FAKE_CLIENT_SECRET' }
  its(:grant_type)   { should eq 'password'}
  its(:domain)       { should eq 'https://api.nvlope.com/' }
  its(:api_version)  { should eq 'v1'}


  describe 'new' do
    context 'with invalid arguments' do
      it 'raises an ArgumentError' do
        expect{
          described_class.new
        }.to raise_error ArgumentError

        expect{
          described_class.new({})
        }.to raise_error ArgumentError, 'username is a required option'

        expect{
          described_class.new(username: 'u')
        }.to raise_error ArgumentError, 'password is a required option'

        expect{
          described_class.new(username: 'u', password: 'p')
        }.to raise_error ArgumentError, 'client_id is a required option'

        expect{
          described_class.new(username: 'u', password: 'p', client_id: 'c')
        }.to raise_error ArgumentError, 'client_secret is a required option'

        expect{
          described_class.new(username: 'u', password: 'p', client_id: 'c', client_secret: 's')
        }.to_not raise_error
      end
    end
  end

  describe '#url' do
    context 'when given "/oauth2/token"' do
      let(:path){ '/oauth2/token' }
      subject{ nvlope.url(path) }
      it { should eq 'https://api.nvlope.com/v1/oauth2/token' }
    end
  end


  describe '#access_token' do
    subject{ nvlope.access_token }
    before do
      expect(HTTParty).to receive(:post).with('https://api.nvlope.com/v1/oauth2/token', query:{
        grant_type:    nvlope.grant_type,
        username:      nvlope.username,
        password:      nvlope.password,
        client_id:     nvlope.client_id,
        client_secret: nvlope.client_secret,
      }).and_return('access_token' => 'FAKE_OAUTH_ACCESS_TOKEN')
    end
    it { should eq 'FAKE_OAUTH_ACCESS_TOKEN'}
  end

  describe '#request' do
    it 'makes an http request via HTTParty' do
      expect(nvlope).to receive(:access_token).and_return('FAKE_ACCESS_TOKEN')
      query = {foo: 'bar'}
      headers = {'Accepts' => 'application/json'}
      expect(HTTParty).to receive(:get).with('https://api.nvlope.com/v1/some/path',
        query: query,
        headers: headers.merge('Authorization' => 'Bearer FAKE_ACCESS_TOKEN'),
      )
      nvlope.request(:get, 'some/path', query: query, headers: headers)
    end
  end

end
