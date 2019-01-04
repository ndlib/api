require 'spec_helper'

describe Aleph::REST::Connection do

  def define_payload 
    {}.tap do |request_payload|
      request_payload[:post_xml] = File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'hold_request.xml')).read
    end
  end

  def connection_stubs
    Faraday::Adapter::Test::Stubs.new do |stub| 
      stub.get('/holds_list') {[ 200, {'Content-Type' => 'text/xml'}, hold_group_response_body]}
      stub.get('/bad_content_url') {[200, {'Content-Type' => 'text/html'}, rest_error_page_body]}
      stub.put('/place_hold_uri') {[ 200, {'Content-Type' => 'text/xml'}, hold_response_body]}
      stub.put('/bad_content_url') {[200, {'Content-Type' => 'text/html'}, rest_error_page_body]}
    end
  end
  
  let(:hold_group_response_body) { File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'hold_group_list.xml')).read }
  let(:hold_response_body) { File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'hold_post.xml')).read }
  let(:rest_error_page_body) { File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'error_response.html')).read }
  let(:faraday_connection) { aleph_rest_connection { connection_stubs } }
  let(:customized_connection) { Aleph::REST::Connection.new(:base_url => 'http://some.api.com', :response_format => 'html', :max_retries => 3) }
  let(:request_payload) { define_payload }
  subject { Aleph::REST::Connection.new }

  describe "::initialize" do

    context "for all connection instances" do
      
      it "instantiates a faraday connection instance" do
        expect(subject.connection_instance).to be_a_kind_of(Faraday::Connection)
      end

      it "sets the retry interval to 0.05" do
        expect(subject.connection_instance.builder.app.instance_variable_get(:@options).interval).to eq 0.05
      end

      it "sets the interval randomness to 1" do
        expect(subject.connection_instance.builder.app.instance_variable_get(:@options).interval_randomness.to_i).to eq 1
      end

      it "sets the backoff factor to 2" do
        expect(subject.connection_instance.builder.app.instance_variable_get(:@options).backoff_factor).to eq 2
      end

      it "sets the request attribute to be url encoded" do
        expect(subject.connection_instance.builder.handlers).to include(Faraday::Request::UrlEncoded)
      end

      it "sets the connection adapter to typhoeus" do
        expect(subject.connection_instance.builder.handlers).to include(Faraday::Adapter::Typhoeus)
      end

    end

    context "when default connection parameters are used" do

      it "sets the base url to the configured value" do
        expect(subject.base_url).to eq 'http://paul.library.nd.edu:1891/'
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

  describe "#get" do

    context "when the returned reponse format is correct" do

      let(:get_response) { subject.get('/holds_list') }

      before(:each) do
        expect(subject).to receive(:connection_instance).and_return(faraday_connection)
      end

      it "should return an accurately parsed response" do
        expect(get_response.hold_grp_list.hold.institution.group.count).to eq(3)
      end

      it "respond with a struct" do
        expect(get_response).to respond_to(:hold_grp_list)
      end

    end

    context "when the returned response format is incorrect" do

      let(:get_response) { subject.get('/bad_content_url') }

      before(:each) do
        expect(subject).to receive(:connection_instance).and_return(faraday_connection)
      end

      it "raises the proper exception" do
        expect{get_response}.to raise_error(Aleph::REST::Connection::Error)
      end

    end

  end
  
  describe "#put" do

    context "when the returned reponse format is correct" do

      let(:put_response) { subject.put('/place_hold_uri', request_payload) }

      before(:each) do
        expect(subject).to receive(:connection_instance).and_return(faraday_connection)
      end

      it "should return an accurately parsed response" do
        expect(put_response.hold_request_parameters.pickup_location).to eq 'HESB'
      end

      it "respond with a struct" do
        expect(put_response).to respond_to(:hold_request_parameters)
      end

    end

    context "when the returned response format is incorrect" do

      let(:put_response) { subject.put('/bad_content_url', request_payload) }

      before(:each) do
        expect(subject).to receive(:connection_instance).and_return(faraday_connection)
      end

      it "raises the proper exception" do
        expect{put_response}.to raise_error(Aleph::REST::Connection::Error)
      end

    end

  end

  describe "#request_body" do

    it "should set the connection request body" do
      subject.request_body = '<xml><test>test</test></xml>'
      expect(subject.request_body).to eq '<xml><test>test</test></xml>' 
    end

    it "should be empty by default" do
      expect(subject.request_body).to eq nil 
    end

  end

end
