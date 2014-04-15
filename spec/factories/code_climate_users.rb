# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :code_climate_user do
    login    ENV["CODE_CLIMATE_LOGIN"]
    password ENV["CODE_CLIMATE_PASSWORD"]
  end
end
