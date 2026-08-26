require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /session/new" do
    it "renders the login form" do
      get new_session_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Username")
    end
  end

  describe "POST /session" do
    before { create_user }

    it "signs in with valid credentials and redirects to root" do
      post session_path, params: { username: "zezima", password: "secret123" }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Signed in as zezima")
    end

    it "is case- and whitespace-insensitive about the username" do
      post session_path, params: { username: "  Zezima ", password: "secret123" }
      expect(response).to redirect_to(root_path)
    end

    it "rejects a wrong password" do
      post session_path, params: { username: "zezima", password: "wrong" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid username or password")
    end

    it "rejects an unknown username" do
      post session_path, params: { username: "nobody", password: "secret123" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid username or password")
    end
  end

  describe "DELETE /session" do
    it "signs out" do
      sign_in(create_user)
      delete session_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).not_to include("Signed in as")
    end
  end
end
