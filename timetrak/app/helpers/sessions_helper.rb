module SessionsHelper
  def login(account)
    session[:account_id] = account.id
  end

  def current_account
    @current_account ||= Account.find_by(id: session[:account_id])
  end

  def logged_in?
    !current_account.nil?
  end
end
