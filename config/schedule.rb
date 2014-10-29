# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#

set :output, "./log/cron_log.log"

set :job_template, 'export $(cat /.dockerenv | sed s/\"//g | sed "s/\,/ /g" | sed \'s/\(\[\|\]\)//g\') && /bin/bash -l -c \':job\''

every 5.minutes do
  runner "IssuesFromApi.new(GithubUser.token_user).update", :environment => ENV["RAILS_ENV"]
end

every 5.minutes do
  runner "TicketsFromApi.new(LighthouseUser.token_user).update", :environment => ENV["RAILS_ENV"]
end

# EB time zone is UTC
every '0 17 * * 1,2,3,4,5' do
  runner "PendingReview.notify", :environment => ENV["RAILS_ENV"]
end
