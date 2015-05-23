class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(username: params[:session][:username])
    if account && account.authenticate(params[:session][:password])
      login account
      params[:session][:remember_me] == '1' ? remember(account) : forget(account)
      redirect_to account
    else
      flash.now[:error] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to welcome_path
  end
end
