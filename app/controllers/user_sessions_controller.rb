class UserSessionsController < ApplicationController
  before_filter :require_user, :only => [:destroy]
  before_filter :require_no_user, :except => [:destroy]
  
  def new
    @user_session = UserSession.new
    render :layout => 'simple'
  end

  def create
  @user_session = UserSession.new(params[:user_session])
  if @user_session.save
    #flash[:notice] = "Successfully logged in."
    redirect_to root_url
  else
    render :action => 'new'
  end
end

def destroy
  @user_session = UserSession.find
  @user_session.destroy
  #reset_session
  #flash[:notice] = "Wylogowanie zakończono pomyślnie."
  redirect_to root_url
end


end
