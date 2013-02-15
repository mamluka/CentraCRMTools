class DriverExtentions
  @@supported_actions = ["email", "select"]

  def initialize(driver)
    @driver = driver
  end

  def supports?(action)
    @@supported_actions.include?(action)
  end

  def select(name, value)
    @driver.select_list(:name => name).select value
  end

  def email(name,value)
    @driver.text_field(:name => 'Leads0emailAddress0').set value
    @driver.button(:id => 'Leads0_email_widget_add').click
  end
end