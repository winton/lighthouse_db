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

every 1.hour do
  runner "IssuesFromApi.new(GithubUser.token_user).update", :environment => ENV["RAILS_ENV"]
end

every '0 10 * * 1,2,3,4,5' do
  runner "IssuesFromApi.new(GithubUser.token_user).update"
  runner "TicketsFromApi.new(LighthouseUser.token_user).update"
  runner "PendingReview.notify"
end
