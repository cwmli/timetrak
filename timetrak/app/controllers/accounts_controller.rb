class AccountsController < ApplicationController
  #responsible for account management
  def show #show account details
    @account = Account.find(params[:id])
  end

  def new
  end

  def create
    @account = Account.new(params.require(:account).permit(:user, :pass, :email))
    if @account.save
      redirect_to action: 'show', notice: 'Account created successfully.'
    else
      render 'new' #failed try again
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to action: 'show', notice: 'Account information updated.'
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
