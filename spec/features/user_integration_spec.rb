require 'spec_helper'

describe "Login" do 
  let(:user) { create(:user) }
  it "logs the user in" do
    user.confirm!
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Sign in"
    page.should have_content "success"
  end
end

describe "Registration" do
  xit "Email not in Action Mailer queue. -DJB" do
    it "registers the user" do
      visit register_path
      fill_in "Username", with: "username"
      fill_in "Email", with: "user@fooda.com"
      fill_in :user_password, with: "secretPassword"
      fill_in :user_password_confirmation, with: "secretPassword"
      click_button "Sign up"
      page.should have_content "email"
      last_email.should have_content "user@fooda.com"
    end
  end
end

# Set to pending until we roll our own.
describe "PasswordResets" do
  let(:user) { create(:user) }
  xit "emails a user when requesting password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"
    current_path.should eq new_user_session_path
    page.should have_content "Email sent"
    # last_emaill is using our ActionMailer::Base.deliveries support method.
    last_email.to.should include(user.email)
  end

  xit "does not email invalid user when requesting password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", with: "nobody@example.com"
    click_button "Send me"
    last_email.should be_nil
  end
end
