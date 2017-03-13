module KasikarisHelper
  def can_edit?
    action_name == "new" || action_name == "create"
  end
end
