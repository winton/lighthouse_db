# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :github_user do
    login     ENV["GITHUB_LOGIN"]
    org       ENV["GITHUB_ORG"]
    token     ENV["GITHUB_TOKEN"]
  end
end
