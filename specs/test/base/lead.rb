require 'securerandom'

require File.dirname(__FILE__) + '/driver-extentions.rb'

class Lead
  def initialize(driver, values = nil)
    values ||= Hash.new
    values = values.merge({:first_name => SecureRandom.uuid, :last_name => SecureRandom.uuid})

    @driver = driver
    driver.goto 'http://crmtesting.centracorporation.com/index.php?module=Leads&action=index&parentTab=Sales'

    driver.link(:text => 'Create').click

    values.each do |key, value|
      driver_extentions = DriverExtentions.new(driver)

      name = key.to_s
      action = value.split(' ')[0]

      if driver_extentions.supports?(action)
        driver_extentions.send(action, name, value.split(' ')[1])
      else
        driver.text_field(:name => name).set value
      end
    end

    driver.button(:value => 'Save').click

    @id = driver.url.match(/record=(.+?)&/)[1]
  end

  def id
    @id
  end
end