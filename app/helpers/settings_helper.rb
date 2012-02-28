module SettingsHelper
  def is_current? (item, cur)
    if item == cur 
      {:class => 'current'}
    else
      {}
    end
  end
end
