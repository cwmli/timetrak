class AccountsController < ApplicationController
  #responsible for account management
  def show #show account details
    @account = Account.find(params[:id])
    @events = @account.events #show all events
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params.require(:account).permit(:username, :password, :password_confirmation, :email))
    if @account.save
      login @account
      remember @account
      flash[:success] = 'Welcome to Timetrak Scheduler!'
      redirect_to @account
    else
      flash.now[:error]
      render 'new' #failed try again
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      render action: 'show', notice: 'Account information updated.'
    else
      render 'edit', notice: 'An error occurred and your information was not updated.' #unsucessful save try again
    end
  end

  def delete
    Account.find(params[:id]).destroy
    redirect_to controller: 'welcome', action: 'index',
      notice: 'Account closed successfully.'
  end
end
