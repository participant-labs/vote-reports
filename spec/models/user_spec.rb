require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it "is created with valid attributes" do
    expect do
      create(:user)
    end.to change(User,:count).by(1)
  end

  it "validates uniqueness of username" do
    user = create(:user, username: 'foo')
    expect do
      user = User.new(username: 'foo')
      user.save
    end.to_not change(User, :count)
    expect(user.errors[:username]).to include("has already been taken")
  end

  describe "#reports" do
    it "includes private reports" do
      private_report = create(:report, user: user)
      expect(user.reports).to include(private_report)
    end

    it "includes personal reports" do
      personal = create(:report, :personal, user: user)
      expect(user.reports).to include(personal)
    end
  end

  describe "#personal_report" do
    it "does not misidentify a non-personal_report" do
      private_report = create(:report, user: user)
      expect(user.personal_report).to_not eq(private_report)
    end
  end
end
