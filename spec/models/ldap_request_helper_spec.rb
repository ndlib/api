require 'spec_helper'

class TestLdapRequestHelper
  include LdapRequestHelper
end

describe 'ldap_request_helper' do
  let(:test_ldap_helper) { TestLdapRequestHelper.new }
  let(:test_ldap_conn) { LdapRequestHelper::LdapConnection.new }
  let(:ldap_entry) { FactoryGirl.build(:ldap_entry) }

  context "provides a valid ldap interface" do

    it "makes successful connection to LDAP" do
      test_ldap_conn.stub(:ldap_bind).and_return(true)
      test_ldap_conn.should_receive(:ldap_bind).once
      ldap_object = test_ldap_conn.build_ldap
      ldap_object.should be_an_instance_of(Net::LDAP)
    end
    it "returns an error if bind operation fails" do
      test_ldap_conn.stub(:ldap_bind).and_return(false)
      expect { test_ldap_conn.build_ldap }.to raise_error(Net::LDAP::LdapError)
    end
    it "returns an error if missing parameters" do
      test_ldap_conn.stub(:ldap_bind).and_return(true)
      expect { test_ldap_conn.build_ldap(:ldap_host => '') }.to raise_error(Net::LDAP::LdapError)
    end

  end

  context "requests entries from LDAP based on criteria" do
    it "can return a valid ldap entry" do
      test_ldap_conn.stub(:ldap_bind).and_return(true)
      test_ldap_conn.stub(:ldap_search).and_return(ldap_entry)
      test_ldap_conn.should_receive(:ldap_search).once
      test_ldap_conn.build_ldap
      test_ldap_helper.ldap_connection(test_ldap_conn)
      test_ldap_helper.ldap_get('fake_attr','fake_val').should eql(ldap_entry)
    end
    it "can parse out LDAP attributes" do
      test_ldap_conn.stub(:ldap_bind).and_return(true)
      test_ldap_conn.stub(:ldap_search).and_return(ldap_entry)
      test_ldap_conn.should_receive(:ldap_search).once
      test_ldap_conn.build_ldap
      test_ldap_helper.ldap_connection(test_ldap_conn)
      test_ldap_helper.ldap_get('fake_attr','fake_val').ndtitle.should eq(ldap_entry.ndtitle)
    end
    it "returns nil if no results found" do
      test_ldap_conn.stub(:ldap_bind).and_return(true)
      test_ldap_conn.stub(:ldap_search).and_return(nil)
      test_ldap_conn.build_ldap
      test_ldap_helper.ldap_connection(test_ldap_conn)
      test_ldap_helper.ldap_get('fake_attr','fake_val').should be_nil
    end

  end

end
