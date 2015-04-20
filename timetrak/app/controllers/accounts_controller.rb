class AccountsController < ApplicationController
  #responsible for account management
  #admins only
  def index
    @account = Account.all
  end

  def show #show account details
    @account = Account.find(params[:id])
  end

  def new
  end

  def create
    @account = Account.new(params.require(:account).permit(:user, :pass, :email))
    if @account.save
      redirect_to @account #show account info
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
      redirect_to @account
    else
      render 'edit' #unsucessful save try again
    end
  end

  def delete
    Account.find(params[:id]).destroy
    redirect_to @account #return to home page
  end
end
