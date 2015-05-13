module TeamsHelper
  def selected_team
      @current_team ||= Team.where(account_id: current_account, name: @team.name)
  end
end
