# frozen_string_literal: true

module Bitly
  module HTTP
    ##
    # The Response class handles generic responses from the API. It is made up
    # of a status code, body and headers. The body is expected to be JSON and it
    # will parse the body. The status should lie within the range 100 - 599 and
    # the headers should be a hash.
    class Response

      # @return [String] The response's status code
      attr_reader :status

      # @return [Hash] The response's parsed body
      attr_reader :body

      # @return [Hash] The response's headers
      attr_reader :headers

      ##
      # Creates a new Bitly::HTTP::Response object, which can be used by other
      # objects in the library.
      #
      # @example
      #     response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
      #
      # @param [String] status The status code of the response, which should be
      #   between 100 and 599
      # @param [String] body The body of the response, a String that is valid
      #   JSON and will be parsed
      # @param [Hash] headers The response headers
      def initialize(status:, body:, headers:)
        errors = []
        @status = status
        errors << "Status must be a valid HTTP status code. Received #{status}" unless is_status?(status)
        begin
          @body = JSON.parse(body)
        rescue => e
          errors << "Body must be valid JSON. Received #{body}"
        end
        @headers = headers
        errors << "Headers must be a hash. Received #{headers}" unless headers.is_a?(Hash)
        raise ArgumentError, errors.join("\n") if errors.any?
      end

      private

      def is_status?(status)
        !!status.match(/\A[1-5][0-9][0-9]\z/)
      end
    end
  end
end