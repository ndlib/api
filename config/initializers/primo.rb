Exlibris::Primo.configure do |config|
  yaml_config = YAML.load_file(Rails.root.join("config/primo.yml"))
  primo_config = yaml_config[Rails.env]

  config.base_url = primo_config["base_url"]
  config.institution = primo_config["institution"]
end
