##LighthouseDb

[![Build Status](https://travis-ci.org/winton/lighthouse_db.svg?branch=master)](https://travis-ci.org/winton/lighthouse_db) [![Code Climate](https://codeclimate.com/repos/533278906956807aae005f2a/badges/6d478f0656290243abfc/gpa.png)](https://codeclimate.com/repos/533278906956807aae005f2a/feed)

Lighthouse API -> DB

###Install

    git clone git@github.com:winton/lighthouse_db.git
    bundle
    cp config/database.example.yml config/database.yml
    rake db:migrate
    rails s

###Download Lighthouse Data

[Set up the Lighthouse user](http://127.0.0.1:3000/admin/lighthouse_users/new)

	rails c
	LighthouseTicket.update_all_from_api!(
      LighthouseUser.first,
      [LIGHTHOUSE PROJECT ID]
    )

Subsequent runs will only download newly updated tickets.

[View Lighthouse tickets](http://127.0.0.1:3000/admin/lighthouse_tickets)

###Screenshot

http://cl.ly/image/2y0p0w0B0Q2V

###Running Specs

Required environmental variables:

  RAILS_ENV=test rake db:migrate  
  LIGHTHOUSE_TOKEN='' LIGHTHOUSE_NAMESPACE='' LIGHTHOUSE_USER_ID='' rspec spec