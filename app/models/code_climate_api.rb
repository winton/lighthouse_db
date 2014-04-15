class CodeClimateApi

  def initialize(*args)
    @user       = args.detect { |a| a.is_a?(CodeClimateUser) }
    @@driver  ||= Selenium::WebDriver.for :firefox
    @base_url   = "https://codeclimate.com/"
    @driver.manage.timeouts.implicit_wait = 20
    login
  end

  def login
    @driver.get("#{@base_url}login")
    @driver.find_element(:id, "login_form_email").clear
    @driver.find_element(:id, "login_form_email").send_keys @user.login
    @driver.find_element(:id, "login_form_password").clear
    @driver.find_element(:id, "login_form_password").send_keys @user.decrypted_password
    @driver.find_element(:css, "input.btn.btn-primary").click
  end

  def quit
    @driver.quit
  end
end