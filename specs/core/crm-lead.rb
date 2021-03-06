require 'securerandom'

require_relative 'driver-extentions.rb'

class CrmLead
  def initialize(driver, values = nil)
    @base_url = JSON.parse(File.read(File.dirname(__FILE__) + '/crm-config.json'))['crm_base_url']
    @driver = driver
    create_new_lead(values)
  end

  def edit(values)
    @driver.goto @base_url  + '/index.php?module=Leads&action=DetailView&record=' + @id
    @driver.link(:id => 'edit_button').click

    set_values(values)

    @driver.button(:value => 'Save').click
  end

  def create_new_lead(values)
    values ||= Hash.new
    values = values.merge({:first_name => SecureRandom.uuid, :last_name => SecureRandom.uuid})

    @driver.goto @base_url  + '/index.php?module=Leads&action=index&parentTab=Sales'

    @driver.link(:text => 'Create').click
    set_values(values)

    @driver.button(:value => 'Save').click

    url_match = @driver.url.match(/record=(.+?)&/)

    unless url_match.nil?
      @id = url_match[1]
    end
  end

  def id
    @id
  end

  def show_all_panels
    (0..5).each { @driver.execute_script("$('.yui-hidden').removeClass('yui-hidden')") }
  end

  def set_values(values)

    show_all_panels

    values.each do |key, value|
      driver_extentions = DriverExtentions.new(@driver)

      name = key.to_s
      action = value.split(' ')[0]

      if driver_extentions.supports?(action)
        array = value.split(' ')
        if array.length > 1
          driver_extentions.send(action, name, value[action.length+1..-1])
        else
          driver_extentions.send(action, name)
        end
      else
        @driver.text_field(:name => name).set value
      end
    end
  end

  def get(name)

    unless @driver.url.include?(@id)
      @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
    end

    show_all_panels

    @driver.span(:id => name).text
  end

  def get_list(id)

    unless @driver.url.include?(@id)
      @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
    end

    show_all_panels

    @driver.hidden(:id => id).value
  end

  def refresh
    @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
  end

  def is_checked(id)
    unless @driver.url.include?(@id)
      @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
    end

    show_all_panels

    @driver.checkbox(:id => id).set?
  end

  def status
    unless @driver.url.include?(@id)
      @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
    end
    show_all_panels

    @driver.execute_script("return $('#status').parent().text().trim()")
  end

  def get_by_label(label)
    unless @driver.url.include?(@id)
      @driver.goto @base_url  + "/index.php?module=Leads&action=DetailView&record=#{@id}"
    end

    show_all_panels

    @driver.execute_script("return $($.grep($('#LBL_CONTACT_INFORMATION td'),function(n,i) { return $(n).text().match(/#{label}:/) })[0]).next().text()")
  end


end