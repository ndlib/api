require 'spec_helper'

describe ExternalRest do

  let(:example_response) { eval(File.open(Rails.root.join('spec', 'fixtures', 'example.json')).read).to_ostruct }

  describe "::initialize" do
    context "with class default parameters" do
      subject { ExternalRest.new(base_url: 'http://some.url.com') }

      it "instantiates a connection" do
        expect(subject.connection).to be_a_kind_of(ExternalRestConnection)
      end

      it "sets the default REST verb" do
        expect(subject.verb).to eq 'get'
      end

      it "sets the default path" do
        expect(subject.path).to eq '/'
      end
    end
  
    context "with custom parameters" do
      subject { ExternalRest.new(base_url: 'http://some.url.com', verb: 'put', path: '/test') }

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
      subject { ExternalRest.new(base_url: 'http://some.url.com', verb: 'put', path: '/test') }

      it "should have minimal default values" do
        opts_vals = {:max_retries=>2}
        expect(subject.connection.opts).to eq opts_vals
      end

    end

    context "when there are connection param overrides" do
      subject { ExternalRest.new( base_url: 'http://another.url.com', connection_opts: {max_retries: 3, response_format: 'html'}) }

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
      subject { ExternalRest.new(base_url: 'http://somewhere', path: '/example_uri') }

      it "returns a response object of type OpenStruct" do
        expect(subject.connection).to receive(:send).with('get', '/example_uri').and_return(example_response)
        expect(subject.transact).to be_a_kind_of(OpenStruct)
      end

    end

    context "with get verb and invalid URI" do
      subject { ExternalRest.new(base_url: 'http://somewhere', path: '/') }

      it "returns an error if request fails" do
        expect(subject.connection).to receive(:send).with('get', '/').and_raise(ExternalRestConnection::Error)
        expect{subject.transact}.to raise_error(ExternalRestConnection::Error)
      end

    end

    context "with put verb and valid URI" do
      subject { ExternalRest.new(base_url: 'http://somewhere', verb: 'put', path: '/example_uri') }

      it "returns a response object of type OpenStruct" do
        expect(subject.connection).to receive(:send).with('put', '/example_uri').and_return(example_response)
        expect(subject.transact).to be_a_kind_of(OpenStruct)
      end

    end

    context "with put verb and invalid URI" do
      subject { ExternalRest.new(base_url: 'http://somewhere', verb: 'put') }

      it "returns an error if request fails" do
        expect(subject.connection).to receive(:send).with('put', '/').and_raise(ExternalRestConnection::Error)
        expect{subject.transact}.to raise_error(ExternalRestConnection::Error)
      end

    end

  end

end
