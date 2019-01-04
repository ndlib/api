require 'spec_helper'

describe Application::Secrets do
  let(:secrets) do
    {
      "ldap" => {
        "service_dn" => "ldap_dn",
        "service_password" => "ldap_pw",
        "attrs" => ["attrs"]
      },
      "worldcat" => {
        "api_key" => "worldcat_key",
        "library_locations" => "library_url",
        "bibliographic_info" => "bib_info_url",
      },
      "secret_key_base" => "secret_base",
      "primo_link_oclc" => "primo_link"
    }
  end

  before(:each) do
    Application::Secrets.class_variable_set :@@secrets, secrets
    Application::Secrets.class_variable_set :@@ldap, nil
    Application::Secrets.class_variable_set :@@worldcat, nil
  end

  it 'gets primo link' do
    expect(Application::Secrets.primo_link_oclc).to eq(secrets["primo_link_oclc"])
  end

  it 'gets secret key' do
    expect(Application::Secrets.secret_key_base).to eq(secrets["secret_key_base"])
  end

  describe "worldcat" do
    it 'gets api key' do
      expect(Application::Secrets.worldcat_api_key).to eq(secrets["worldcat"]["api_key"])
    end

    it 'gets library locations' do
      expect(Application::Secrets.worldcat_library_locations).to eq(secrets["worldcat"]["library_locations"])
    end

    it 'gets bib info' do
      expect(Application::Secrets.worldcat_bibliographic_info).to eq(secrets["worldcat"]["bibliographic_info"])
    end
  end

  describe "ldap" do
    it 'gets dn' do
      expect(Application::Secrets.ldap_service_dn).to eq(secrets["ldap"]["service_dn"])
    end

    it 'gets password' do
      expect(Application::Secrets.ldap_service_password).to eq(secrets["ldap"]["service_password"])
    end

    it 'gets attributes' do
      expect(Application::Secrets.ldap_attrs).to eq(secrets["ldap"]["attrs"])
    end
  end

  after(:all) do
    Application::Secrets.class_variable_set :@@secrets, nil
    Application::Secrets.class_variable_set :@@ldap, nil
    Application::Secrets.class_variable_set :@@worldcat, nil
  end
end
