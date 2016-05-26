# -*- encoding: utf-8 -*-

module SendGrid4r::REST
  module Settings
    #
    # SendGrid Web API v3 Settings - Mail
    #
    module Mail
      include Request

      AddressWhitelist = Struct.new(:enabled, :list)

      def self.create_address_whitelist(resp)
        return resp if resp.nil?
        AddressWhitelist.new(resp['enabled'], resp['list'])
      end

      Bcc = Struct.new(:enabled, :email)

      def self.create_bcc(resp)
        return resp if resp.nil?
        Bcc.new(resp['enabled'], resp['email'])
      end

      BouncePurge = Struct.new(:enabled, :hard_bounces, :soft_bounces)

      def self.create_bounce_purge(resp)
        return resp if resp.nil?
        BouncePurge.new(
          resp['enabled'], resp['hard_bounces'], resp['soft_bounces']
        )
      end

      Footer = Struct.new(:enabled, :html_content, :plain_content)

      def self.create_footer(resp)
        return resp if resp.nil?
        Footer.new(
          resp['enabled'], resp['html_content'], resp['plain_content']
        )
      end

      ForwardBounce = Struct.new(:enabled, :email)

      def self.create_forward_bounce(resp)
        return resp if resp.nil?
        ForwardBounce.new(resp['enabled'], resp['email'])
      end

      ForwardSpam = Struct.new(:enabled, :email)

      def self.create_forward_spam(resp)
        return resp if resp.nil?
        ForwardSpam.new(resp['enabled'], resp['email'])
      end

      Template = Struct.new(:enabled, :html_content)

      def self.create_template(resp)
        return resp if resp.nil?
        Template.new(resp['enabled'], resp['html_content'])
      end

      PlainContent = Struct.new(:enabled)

      def self.create_plain_content(resp)
        return resp if resp.nil?
        PlainContent.new(resp['enabled'])
      end

      SpamCheck = Struct.new(:enabled, :url, :max_score)

      def self.create_spam_check(resp)
        return resp if resp.nil?
        SpamCheck.new(resp['enabled'], resp['url'], resp['max_score'])
      end

      def self.url(name = nil)
        url = "#{BASE_URL}/mail_settings"
        url = "#{url}/#{name}" unless name.nil?
        url
      end

      def get_mail_settings(limit: nil, offset: nil, &block)
        params = {}
        params[:limit] = limit unless limit.nil?
        params[:offset] = offset unless offset.nil?
        resp = get(@auth, Settings::Mail.url, params, &block)
        Settings.create_results(resp)
      end

      def get_settings_address_whitelist(&block)
        resp = get(@auth, Settings::Mail.url(:address_whitelist), &block)
        Settings::Mail.create_address_whitelist(resp)
      end

      def patch_settings_address_whitelist(params:, &block)
        endpoint = Settings::Mail.url(:address_whitelist)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_address_whitelist(resp)
      end

      def get_settings_bcc(&block)
        resp = get(@auth, Settings::Mail.url(:bcc), &block)
        Settings::Mail.create_bcc(resp)
      end

      def patch_settings_bcc(params:, &block)
        endpoint = Settings::Mail.url(:bcc)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_bcc(resp)
      end

      def get_settings_bounce_purge(&block)
        resp = get(@auth, Settings::Mail.url(:bounce_purge), &block)
        Settings::Mail.create_bounce_purge(resp)
      end

      def patch_settings_bounce_purge(params:, &block)
        endpoint = Settings::Mail.url(:bounce_purge)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_bounce_purge(resp)
      end

      def get_settings_footer(&block)
        resp = get(@auth, Settings::Mail.url(:footer), &block)
        Settings::Mail.create_footer(resp)
      end

      def patch_settings_footer(params:, &block)
        resp = patch(@auth, Settings::Mail.url(:footer), params.to_h, &block)
        Settings::Mail.create_footer(resp)
      end

      def get_settings_forward_bounce(&block)
        resp = get(@auth, Settings::Mail.url(:forward_bounce), &block)
        Settings::Mail.create_forward_bounce(resp)
      end

      def patch_settings_forward_bounce(params:, &block)
        endpoint = Settings::Mail.url(:forward_bounce)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_forward_bounce(resp)
      end

      def get_settings_forward_spam(&block)
        resp = get(@auth, Settings::Mail.url(:forward_spam), &block)
        Settings::Mail.create_forward_spam(resp)
      end

      def patch_settings_forward_spam(params:, &block)
        endpoint = Settings::Mail.url(:forward_spam)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_forward_spam(resp)
      end

      def get_settings_template(&block)
        resp = get(@auth, Settings::Mail.url(:template), &block)
        Settings::Mail.create_template(resp)
      end

      def patch_settings_template(params:, &block)
        endpoint = Settings::Mail.url(:template)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_template(resp)
      end

      def get_settings_plain_content(&block)
        resp = get(@auth, Settings::Mail.url(:plain_content), &block)
        Settings::Mail.create_plain_content(resp)
      end

      def patch_settings_plain_content(params:, &block)
        endpoint = Settings::Mail.url(:plain_content)
        resp = patch(@auth, endpoint, params.to_h, &block)
        Settings::Mail.create_plain_content(resp)
      end

      def get_settings_spam_check(&block)
        endpoint = SendGrid4r::REST::Settings::Mail.url("spam_check")
        resp = get(@auth, endpoint, &block)
        SendGrid4r::REST::Settings::Mail.create_spam_check(resp)
      end

      def patch_settings_spam_check(params:, &block)
        endpoint = SendGrid4r::REST::Settings::Mail.url("spam_check")
        resp = patch(@auth, endpoint, params.to_h, &block)
        SendGrid4r::REST::Settings::Mail.create_spam_check(resp)
      end
    end
  end
end
