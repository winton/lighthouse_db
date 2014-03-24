##LighthouseDb

Lighthouse API -> DB

###Install

    git clone git@github.com:winton/lighthouse_db.git
    bundle
    rake db:migrate
    rails s

###Download Lighthouse Data

[Set up the Lighthouse user](http://127.0.0.1:3000/admin/lighthouse_users/new)

	rails c
	LighthouseUser.first.update_from_api!([LIGHTHOUSE PROJECT ID])

Subsequent runs will only download newly updated tickets.

[View Lighthouse tickets](http://127.0.0.1:3000/admin/lighthouse_tickets)

###Screenshot

http://cl.ly/image/2y0p0w0B0Q2V