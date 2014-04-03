FactoryGirl.define do
  factory :lighthouse_user do
    lighthouse_id ENV["LIGHTHOUSE_USER_ID"]
    project_id    ENV["LIGHTHOUSE_PROJECT_ID"]
    namespace     ENV["LIGHTHOUSE_NAMESPACE"]
    token         ENV["LIGHTHOUSE_TOKEN"]
  end
end
