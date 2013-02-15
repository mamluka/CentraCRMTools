class Lead
  def initialize(driver, information = nill?)
    information ||= {:first_name => SecureRandom.uuid, :last_name => SecureRandom.uuid}

    @driver = driver
    driver.goto 'http://crmtesting.centracorporation.com/index.php?module=Leads&action=index&parentTab=Sales'

    driver.link(:text => 'Create').click

    driver.text_input(:name => 'first_name').set information[:first_name]
    driver.text_input(:name => 'last_name').set information[:last_name]

    driver.button(:value => 'Submit').click

    puts driver.url

    driver.url.match(/record=(.+?)&/)[1]
  end
end