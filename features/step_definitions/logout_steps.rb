Given(/^I am at my dashboard$/) do
  visit login_path
  save_and_open_page
  fill_in 'Email', :with => 'p.sweetpotato@gmail.com'
      fill_in 'Password', :with => 'potatoes4eva'
      click_button('Login')
end

When(/^I click the log out button$/) do
  save_and_open_page
  click_link('Logout')
end
