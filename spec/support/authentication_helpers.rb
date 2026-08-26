module AuthenticationHelpers
  def create_user(username: "zezima", password: "secret123", role: :admin)
    User.create!(username:, password:, role:)
  end

  def sign_in(user, password: "secret123")
    post session_path, params: { username: user.username, password: }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
