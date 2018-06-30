require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

# This is a workaround for https://github.com/kern/minitest-reporters/issues/230
Minitest.load_plugins
Minitest.extensions.delete('rails')
Minitest.extensions.unshift('rails')

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  def is_logged_in?
    begin
      !!session[:user_id]
    rescue NoMethodError => e
      false
    end
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
