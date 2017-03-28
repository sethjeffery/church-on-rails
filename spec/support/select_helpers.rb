module SelectHelpers
  def select_ajax(field_name, id, text)
    # Select2 is notoriously difficult to test in Capybara
    # and it gets the results by AJAX
    # so we will just hack the options into it
    expect(page).to have_selector "[name='#{field_name}']"
    page.execute_script("$(\"[name='#{field_name}']\").append('<option value=#{id}>#{text}</option>')")
    select text, from: field_name
  end
end

RSpec.configure do |config|
  config.include SelectHelpers
end
