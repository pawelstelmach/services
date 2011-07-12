class UsersController < ApplicationController
before_filter :require_user, :only => [:edit, :update]
before_filter :require_no_user, :except => [:edit, :update]
  
def new
  @user = User.new
  render :layout => 'simple'
end

def create
  @user = User.new(params[:user])
  if @user.save
    #@user.create_default_settings
    flash[:notice] = "Profil został pomyślnie utworzony."
    redirect_to root_url
  else
    render :action => 'new'
  end
end

def edit
  @user = current_user
end

def update
  @user = current_user
  if @user.update_attributes(params[:user])
    flash[:notice] = "Profil został pomyślnie zaktualizowany."
    redirect_to root_url
  else
    render :action => 'edit'
  end
end

end
