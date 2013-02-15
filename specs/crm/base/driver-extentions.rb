class DriverExtentions
  @@supported_actions = ["email", "select", "check", "uncheck"]

  def initialize(driver)
    @driver = driver
  end

  def supports?(action)
    @@supported_actions.include?(action)
  end

  def select(name, value)
    @driver.select_list(:name => name).select value
  end

  def check(name)
    @driver.checkbox(:name => name).set
  end

  def uncheck(name)
    @driver.checkbox(:name => name).clear
  end

  def email(name, value)
    @driver.text_field(:name => 'Leads0emailAddress0').set value
  end
end