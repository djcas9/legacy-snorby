
## Snorby Admin User
user = User.create(:name => 'Snorby Administrator', 
:email => 'snorby@snorby.org', 
:password => 'admin', 
:password_confirmation => 'admin', 
:admin => true,
:resolve_ips => true, 
:accept_email => true)    
user.save!