require 'spec_helper'

class TestHttpRequestHelper
  include HttpRequestHelper
end

describe 'http_request_helper' do
  let(:test_object) { TestHttpRequestHelper.new }

  let(:ssl_test_urls) { ["https://localhost:33234", "HTTPS://bla.bla.com", "HtTPs://something.com/asdfsadf.json"] }
  let(:non_ssl_test_urls) { [ "http://localhost:234234", "HTTP://bla.bla.com", "HtTP://something.com/asdfsadf.json"] }

  describe "determine ssl" do

    it "detects if the requests is ssl and changes the requests to an http requests" do
      ssl_test_urls.each do | url |
        url = URIParser.call(url)
        expect(Faraday).to receive(:new).with(:url => "#{url.scheme}://#{url.host}")

        TestHttpRequestHelper.send(:build_http, url)
     end
    end


    it "detects if the requests is not over ssl and sets it appropriately" do
      non_ssl_test_urls.each do | url |
        url = URIParser.call(url)
        expect(Faraday).to receive(:new).with(:url => "#{url.scheme}://#{url.host}")

        TestHttpRequestHelper.send(:build_http, url)
      end
    end

  end


  it "makes a get requests and returns the body of that requests" do
    TestHttpRequestHelper.stub(:http_get_request).and_return("SUCCESS")

    (ssl_test_urls + non_ssl_test_urls).each do | url |
      TestHttpRequestHelper.http_get(url).should == "SUCCESS"
    end
  end

end
