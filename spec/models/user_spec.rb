require "rails_helper"

RSpec.describe User, type: :model do
  def build_user(**attrs)
    User.new(username: "zezima", password: "secret123", role: :admin, **attrs)
  end

  describe "validations" do
    it "is valid with a username, password, and role" do
      expect(build_user).to be_valid
    end

    it "requires a username" do
      expect(build_user(username: "")).not_to be_valid
    end

    it "requires a unique username" do
      build_user.save!
      expect(build_user).not_to be_valid
    end

    it "treats usernames differing only by case/whitespace as duplicates" do
      build_user.save!
      expect(build_user(username: "  Zezima ")).not_to be_valid
    end

    it "requires a role" do
      expect(build_user(role: nil)).not_to be_valid
    end
  end

  describe "username normalization" do
    it "strips and downcases the username" do
      expect(build_user(username: "  Zezima ").username).to eq("zezima")
    end
  end

  describe "password authentication" do
    it "authenticates with the correct password" do
      user = build_user.tap(&:save!)
      expect(User.authenticate_by(username: "zezima", password: "secret123")).to eq(user)
    end

    it "rejects a wrong password" do
      build_user.save!
      expect(User.authenticate_by(username: "zezima", password: "wrong")).to be_nil
    end

    it "rejects an unknown username" do
      expect(User.authenticate_by(username: "nobody", password: "secret123")).to be_nil
    end
  end

  describe "roles" do
    it "supports the admin role" do
      expect(build_user).to be_admin
    end

    it "rejects unknown roles" do
      expect(build_user(role: :wizard)).not_to be_valid
    end
  end
end
