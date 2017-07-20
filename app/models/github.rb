class Github
  class Client
    delegate :issues, :issue, to: :client

    class << self
      delegate :issues, :issue, to: :client

      def client
        @client ||= Octokit::Client.new(access_token: token)
      end

      def token
        ENV['GITHUB_TOKEN']
      end
    end

    def client
      self.class.client
    end
  end
end
