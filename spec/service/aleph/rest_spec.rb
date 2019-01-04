require 'spec_helper'

describe Aleph::REST do

  let(:hold_group_response) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'hold_group_list.rb')).read).to_ostruct }
  let(:hold_response) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'hold_post.rb')).read).to_ostruct }

  describe "::initialize" do
    context "with class default parameters" do
      subject { Aleph::REST.new }

      it "instantiates a connection" do
        expect(subject.connection).to be_a_kind_of(Aleph::REST::Connection)
      end

      it "sets the default REST verb" do
        expect(subject.verb).to eq 'get'
      end

      it "sets the default path" do
        expect(subject.path).to eq '/'
      end
    end
  
    context "with custom parameters" do
      subject { Aleph::REST.new(verb: 'put', path: '/test') }

      it "sets a custom REST verb" do
        expect(subject.verb).to eq 'put'
      end

      it "sets a custom path" do
        expect(subject.path).to eq '/test'
      end
    end
  end

  describe "#connection" do

    context "with default connection parameters" do
      subject { Aleph::REST.new }

      it "should have minimal default values" do
        opts_vals = {:base_url=>"http://paul.library.nd.edu:1891/", :max_retries=>2}
        expect(subject.connection.opts).to eq opts_vals
      end

    end

    context "when there are connection param overrides" do
      subject { Aleph::REST.new(max_retries: 3, base_url: 'http://another.url.com', response_format: 'html') }

      it "sets the max retries value" do
        expect(subject.connection.max_retries).to eq 3
      end

      it "sets the base url value" do
        expect(subject.connection.base_url).to eq 'http://another.url.com'
      end

      it "sets the response format" do
        expect(subject.connection.response_format).to eq 'html'
      end
    end

  end

  describe "#transact()" do

    context "with get verb and valid URI" do
      subject { Aleph::REST.new(path: '/hold_group_uri') }

      it "returns a response object of type OpenStruct" do
        expect(subject.connection).to receive(:send).with('get', '/hold_group_uri').and_return(hold_group_response)
        expect(subject.transact).to be_a_kind_of(OpenStruct)
      end

    end

    context "with get verb and invalid URI" do
      subject { Aleph::REST.new(path: '/') }

      it "returns an error if request fails" do
        expect(subject.connection).to receive(:send).with('get', '/').and_raise(Aleph::REST::Connection::Error)
        expect{subject.transact}.to raise_error(Aleph::REST::Connection::Error)
      end

    end

    context "with put verb and valid URI" do
      subject { Aleph::REST.new(verb: 'put', path: '/hold_request_uri') }

      it "returns a response object of type OpenStruct" do
        expect(subject.connection).to receive(:send).with('put', '/hold_request_uri').and_return(hold_response)
        expect(subject.transact).to be_a_kind_of(OpenStruct)
      end

    end

    context "with put verb and invalid URI" do
      subject { Aleph::REST.new(verb: 'put') }

      it "returns an error if request fails" do
        expect(subject.connection).to receive(:send).with('put', '/').and_raise(Aleph::REST::Connection::Error)
        expect{subject.transact}.to raise_error(Aleph::REST::Connection::Error)
      end

    end

  end

end
