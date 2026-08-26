require "rails_helper"

RSpec.describe "Home", type: :request do
  it "shows the coming soon page at root" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Coming soon")
  end

  it "does not show the login form" do
    get root_path
    expect(response.body).not_to include("Password")
  end

  it "shows the signed-in state for an authenticated admin" do
    sign_in(create_user)
    get root_path
    expect(response.body).to include("Signed in as zezima")
  end
end
