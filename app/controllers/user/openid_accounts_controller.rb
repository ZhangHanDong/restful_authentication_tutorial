class User::OpenidAccountsController < ApplicationController
  before_filter :login_prohibited, :only => [ :new, :create ]
	before_filter :login_required, :only => [ :edit, :update ]

	def new

	end

	def create
    logout_keeping_session!
    @user = OpenidUser.new(params[:user])
		@user.identity_url = params[:user][:identity_url]
    success = @user && @user.save
    if success && @user.errors.empty?
			session[:identity_url] = nil			
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash.now[:error]  = "Sorry, we couldn't set up that account.  Please correct the errors and try again, or %s."
			flash[:error_item] = ["sign up for a regular account", new_user_profile_path]
      render :action => 'new'
    end
	end

	def edit
		@user = OpenidUser.find_by_login(current_user.login)
  end

  def update
    @user = OpenidUser.find_by_login(current_user.login)
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
      redirect_to user_profile_path
    else
			flash.now[:error] = "There was a problem updating your profile."
      render :action => 'edit'
    end
  end

end

