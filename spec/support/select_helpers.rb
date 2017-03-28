module SelectHelpers
  def select_ajax(field_name, id, text)
    # Select2 is notoriously difficult to test in Capybara
    # and it gets the results by AJAX
    # so we will just hack the options into it

    expect(page).to have_selector "[name='#{field_name}']"

    if @current_example.metadata[:js]
      execute_script("$(\"[name='#{field_name}']\").append(\"<option value='#{id}'>#{text}</option>\")")
    else
      find("[name='#{field_name}']").native.add_child("<option value='#{id}'>#{text}</option>")
    end

    select text, from: field_name
  end
end

RSpec.configure do |config|
  config.include SelectHelpers
  config.before(:each) { |ex| @current_example = ex }
end
