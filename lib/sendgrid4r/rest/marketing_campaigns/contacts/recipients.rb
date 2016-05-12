# -*- encoding: utf-8 -*-

module SendGrid4r::REST
  module MarketingCampaigns
    module Contacts
      #
      # SendGrid Web API v3 Contacts - Recipients
      #
      module Recipients
        include Request

        Recipient = Struct.new(
          :created_at,
          :custom_fields,
          :email,
          :first_name,
          :id,
          :last_clicked,
          :last_emailed,
          :last_name,
          :last_opened,
          :updated_at
        )

        Recipients = Struct.new(:recipients)

        def self.create_recipient(resp)
          return resp if resp.nil?
          custom_fields = []
          custom_fields = resp['custom_fields'].map do |field|
            Contacts::CustomFields.create_field(field)
          end unless resp['custom_fields'].nil?
          Recipient.new(
            Time.at(resp['created_at']), custom_fields,
            resp['email'], resp['first_name'], resp['id'],
            resp['last_clicked'], resp['last_emailed'],
            resp['last_name'], resp['last_opened'],
            Time.at(resp['updated_at'])
          )
        end

        def self.create_recipients(resp)
          return resp if resp.nil?
          recipients = resp['recipients'].map do |recipient|
            Contacts::Recipients.create_recipient(recipient)
          end
          Recipients.new(recipients)
        end

        def self.url(recipient_id = nil)
          url = "#{BASE_URL}/contactdb/recipients"
          url = "#{url}/#{recipient_id}" unless recipient_id.nil?
          url
        end

        def post_recipients(params:, &block)
          resp = post(@auth, Contacts::Recipients.url, params, &block)
          Contacts::Recipients.create_result(resp)
        end

        def patch_recipients(params:, &block)
          resp = patch(@auth, Contacts::Recipients.url, params, &block)
          Contacts::Recipients.create_result(resp)
        end

        def delete_recipients(recipient_ids:, &block)
          delete(@auth, Contacts::Recipients.url, nil, recipient_ids, &block)
        end

        def get_recipients(page: nil, page_size: nil, &block)
          params = {}
          params['page_size'] = page_size unless page_size.nil?
          params['page'] = page unless page.nil?
          resp = get(@auth, Contacts::Recipients.url, params, &block)
          Contacts::Recipients.create_recipients(resp)
        end

        def get_recipient(recipient_id:, &block)
          resp = get(@auth, Contacts::Recipients.url(recipient_id), &block)
          Contacts::Recipients.create_recipient(resp)
        end

        def delete_recipient(recipient_id:, &block)
          delete(@auth, Contacts::Recipients.url(recipient_id), &block)
        end

        def get_lists_recipient_belong(recipient_id:, &block)
          resp = get(
            @auth, "#{Contacts::Recipients.url(recipient_id)}/lists", &block
          )
          Contacts::Lists.create_lists(resp)
        end

        def get_recipients_count(&block)
          resp = get(@auth, "#{Contacts::Recipients.url}/count", &block)
          resp['recipient_count'] unless resp.nil?
        end

        def search_recipients(params:, &block)
          resp = get(@auth, "#{Contacts::Recipients.url}/search", params, &block)
          Contacts::Recipients.create_recipients(resp)
        end

        Result = Struct.new(
          :error_count,
          :error_indices,
          :new_count,
          :persisted_recipients,
          :updated_count,
          :errors
        )

        def self.create_result(resp)
          return resp if resp.nil?
          errors = resp['errors'].map do |error|
            Contacts::Recipients.create_error(error)
          end unless resp['errors'].nil?
          Result.new(
            resp['error_count'], resp['error_indices'], resp['new_count'],
            resp['persisted_recipients'], resp['updated_count'], errors
          )
        end

        Error = Struct.new(:error_indices, :message)

        def self.create_error(resp)
          return resp if resp.nil?
          Error.new(resp['error_indices'], resp['message'])
        end
      end
    end
  end
end