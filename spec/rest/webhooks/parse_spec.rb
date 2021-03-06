# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe SendGrid4r::REST::Webhooks::Parse do
  describe 'integration test', :it do
    before do
      begin
        Dotenv.load
        @client = SendGrid4r::Client.new(api_key: ENV['API_KEY'])
      rescue RestClient::ExceptionWithResponse => e
        puts e.inspect
        raise e
      end
    end

    context 'without block call' do
      it '#get_parse_settings' do
        begin
          parse_settings = @client.get_parse_settings
          expect(parse_settings).to be_a(
            SendGrid4r::REST::Webhooks::Parse::ParseSettings
          )
          expect(parse_settings.result).to be_a(Array)
        rescue RestClient::ExceptionWithResponse => e
          puts e.inspect
          raise e
        end
      end
    end
  end

  describe 'unit test', :ut do
    let(:client) do
      SendGrid4r::Client.new(api_key: '')
    end

    let(:parse_settings) do
      JSON.parse(
        '{'\
          '"result": ['\
            '{'\
              '"url": "http://mydomain.com/parse",'\
              '"hostname": "mail.mydomain.com",'\
              '"spam_check_outgoing": true'\
            '}'\
          ']'\
        '}'
      )
    end

    let(:parse_setting) do
      JSON.parse(
        '{'\
          '"url": "http://mydomain.com/parse",'\
          '"hostname": "mail.mydomain.com",'\
          '"spam_check_outgoing": true'\
        '}'\
      )
    end

    it '#get_parse_settings' do
      allow(client).to receive(:execute).and_return(parse_settings)
      actual = client.get_parse_settings
      expect(actual).to be_a(
        SendGrid4r::REST::Webhooks::Parse::ParseSettings
      )
    end

    it 'creates parse_setting instance' do
      actual = SendGrid4r::REST::Webhooks::Parse.create_parse_setting(
        parse_setting
      )
      expect(actual).to be_a(
        SendGrid4r::REST::Webhooks::Parse::ParseSetting
      )
      expect(actual.url).to eq('http://mydomain.com/parse')
      expect(actual.hostname).to eq('mail.mydomain.com')
      expect(actual.spam_check_outgoing).to eq(true)
    end

    it 'creates parse_settings instance' do
      actual = SendGrid4r::REST::Webhooks::Parse.create_parse_settings(
        parse_settings
      )
      expect(actual).to be_a(
        SendGrid4r::REST::Webhooks::Parse::ParseSettings
      )
      expect(actual.result).to be_a(Array)
    end
  end
end
