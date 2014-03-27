require 'aws-sdk'

namespace :vcr do

  s3_vcr_dir = "lighthouse_db/vcr"
  vcr_dir    = "#{Rails.root}/spec/fixtures/vcr"

  def s3_bucket
    s3 = AWS::S3.new
    s3.buckets[ENV['S3_BUCKET']]
  end

  desc "Download VCR fixture from S3"
  task :download do
    FileUtils.mkdir_p(vcr_dir)
    s3_bucket.objects.with_prefix("#{s3_vcr_dir}/").each do |obj|
      File.open("#{vcr_dir}/#{File.basename(obj.key)}", 'w') do |f|
        f.write(obj.read)
      end
    end
  end

  desc "Upload VCR fixture to S3"
  task :upload do
    bucket = s3_bucket
    Dir.glob("#{vcr_dir}/*.yml").each do |path|
      obj = bucket.objects["#{s3_vcr_dir}/#{File.basename(path)}"]
      obj.write(File.read(path))
    end
  end
end