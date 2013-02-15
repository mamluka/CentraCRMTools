require 'securerandom'

require File.dirname(__FILE__) + '/driver-extentions.rb'

class Lead
  def initialize(driver, values = nil)
    @driver = driver
    create_new_lead(values)
  end

  def create_new_lead(values)
    values ||= Hash.new
    values = values.merge({:first_name => SecureRandom.uuid, :last_name => SecureRandom.uuid})

    @driver.goto 'http://crmtesting.centracorporation.com/index.php?module=Leads&action=index&parentTab=Sales'

    @driver.link(:text => 'Create').click
    set_values(values)

    @driver.button(:value => 'Save').click

    if @driver.button(:value => '  Save  ').exists?
      @driver.button(:value => '  Save  ').click
    end

    url_match = @driver.url.match(/record=(.+?)&/)

    unless url_match.nil?
      @id = url_match[1]
    end
  end

  def id
    @id
  end

  def show_all_panels
    @driver.execute_script("$('.yui-hidden').removeClass('yui-hidden')")
  end

  def set_values(values)

    show_all_panels

    values.each do |key, value|
      driver_extentions = DriverExtentions.new(@driver)

      name = key.to_s
      action = value.split(' ')[0]

      if driver_extentions.supports?(action)
        driver_extentions.send(action, name, value.split(' ')[1])
      else
        @driver.text_field(:name => name).set value
      end
    end
  end

  def get(name)
    @driver.goto "http://crmtesting.centracorporation.com/index.php?module=Leads&action=DetailView&record=#{@id}"
    show_all_panels

    @driver.span(:id => name).text
  end

  def status
    @driver.goto "http://crmtesting.centracorporation.com/index.php?module=Leads&action=DetailView&record=#{@id}"
    show_all_panels

    @driver.execute_script("return $('#status').parent().text().trim()")
  end
end