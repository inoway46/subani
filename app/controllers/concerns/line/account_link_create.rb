module Line
  module AccountLinkCreate
    extend ActiveSupport::Concern
    included do
      def create_token(uid)
        response = client.create_link_token(uid).body
        JSON.parse(response)
      end

      def create_uri(link_token)
        uri = URI("https://subani.net/line/link")
        uri.query = URI.encode_www_form({ linkToken: link_token["linkToken"] })
        uri
      end
    end
  end
end
