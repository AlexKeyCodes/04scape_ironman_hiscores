require "rails_helper"

RSpec.describe "Authentication concern", type: :request do
  before do
    stub_const("SecretsController", Class.new(ApplicationController) do
      before_action :require_authentication

      def show
        render plain: "the secret"
      end
    end)

    Rails.application.routes.draw do
      resource :session, only: %i[new create destroy]
      root "sessions#new"
      get "secret", to: "secrets#show"
    end
  end

  after { Rails.application.reload_routes! }

  it "redirects to the login page when not signed in" do
    get "/secret"
    expect(response).to redirect_to(new_session_path)
  end

  it "lets a signed-in user through" do
    sign_in(create_user)
    get "/secret"
    expect(response.body).to eq("the secret")
  end

  it "returns to the originally requested page after signing in" do
    create_user
    get "/secret"
    post session_path, params: { username: "zezima", password: "secret123" }
    expect(response).to redirect_to("/secret")
  end
end
