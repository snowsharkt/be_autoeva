module DeviseRequestSpecHelpers
  include Warden::Test::Helpers

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end

RSpec.configure do |config|
  config.include DeviseRequestSpecHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :request
end
