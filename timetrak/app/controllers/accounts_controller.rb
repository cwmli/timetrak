class AccountsController < ApplicationController
  #responsible for account management
  def show
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to :action => 'show' #show account info
    else
      render :action => 'new' #failed try again
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to :action => 'show', :id => @account
    else
      render :action => 'edit' #unsucessful save try again
    end
  end

  def delete
    Account.find(params[:id]).destroy
    redirect_to :action => 'index' #return to home page
  end
end
