require 'spec_helper'

describe ExternalRestConnection do
  
  let(:customized_connection) { ExternalRestConnection.new(base_url: 'http://some.api.com', connection_opts: {response_format: 'html', max_retries: 3}) }
  subject { ExternalRestConnection.new(base_url: 'http://some.crazy.url') }

  describe "::initialize" do

    context "for all connection instances" do
      
      it "instantiates a faraday connection instance" do
        expect(subject.connection).to be_a_kind_of(Faraday::Connection)
      end

      it "sets the retry interval to 0.05" do
        expect(subject.connection.builder.app.instance_variable_get(:@options).interval).to eq 0.05
      end

      it "sets the interval randomness to 1" do
        expect(subject.connection.builder.app.instance_variable_get(:@options).interval_randomness.to_i).to eq 1
      end

      it "sets the backoff factor to 2" do
        expect(subject.connection.builder.app.instance_variable_get(:@options).backoff_factor).to eq 2
      end

      it "sets the request attribute to be url encoded" do
        expect(subject.connection.builder.handlers).to include(Faraday::Request::UrlEncoded)
      end

      it "sets the connection adapter to typhoeus" do
        expect(subject.connection.builder.handlers).to include(Faraday::Adapter::Typhoeus)
      end

    end

    context "when default connection parameters are used" do

      it "sets the base url to the configured value" do
        expect(subject.base_url).to eq 'http://some.crazy.url'
      end

      it "sets the max retry attempts to 2" do
        expect(subject.max_retries).to eq 2
      end

      it "sets the response format to xml" do
        expect(subject.response_format).to eq 'xml'
      end

    end

    context "when connection parameters are manually set" do

      it "sets the max retry attempts" do
        expect(customized_connection.max_retries).to eq 3
      end

      it "sets the correct base url" do
        expect(customized_connection.base_url).to eq 'http://some.api.com'
      end

      it "sets the expected response format" do
        expect(customized_connection.response_format).to eq 'html'
      end

    end

  end
end
