require 'securerandom'

class Lead
  def initialize(driver, values = nil)
    values ||= Hash.new
    values = values.merge({:first_name => SecureRandom.uuid, :last_name => SecureRandom.uuid})

    @driver = driver
    driver.goto 'http://crmtesting.centracorporation.com/index.php?module=Leads&action=index&parentTab=Sales'

    driver.link(:text => 'Create').click

    values.each do |key, value|
      driver.text_field(:name => key.to_s).set value
    end

    driver.button(:value => 'Save').click

    @id = driver.url.match(/record=(.+?)&/)[1]
  end

  def id
    @id
  end
end