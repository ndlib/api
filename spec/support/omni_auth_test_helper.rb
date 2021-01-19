OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:okta] = OmniAuth::AuthHash.new({
    provider: 'okta',
    email: 'test@nd.edu',
    email_verified: true,
    family_name: 'User',
    given_name: 'Test',
    locale: 'en-US',
    name: 'Test User',
    netid: 'testuser'
})
OmniAuth.config.add_mock(:okta, OmniAuth.config.mock_auth[:okta])