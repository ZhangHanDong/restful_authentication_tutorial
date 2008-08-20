require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
	include Authentication::UserAbstraction

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
	# Add identity_url if you want users to be able to update their OpenID identity
	# Because role_ids is included, never mass assign a User
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role_ids

	def to_xml(options = {})
		#Add attributes accessible by xml
  	#Ex. default_only = [:id, :login, :name]
		default_only = []
  	options[:only] = (options[:only] || []) + default_only
  	super(options)
  end

end
