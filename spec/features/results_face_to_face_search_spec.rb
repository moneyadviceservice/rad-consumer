RSpec.feature 'Results page, consumer requires help with their pension in person' do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Using only a valid postcode' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_valid_postcode
      when_i_submit_the_search
      then_i_see_firms_that_cover_my_postcode
    end
  end

  scenario 'Using an invalid postcode' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_an_invalid_postcode
      when_i_submit_the_search
      then_i_see_an_error_message_for_the_postcode_field
      and_i_see_a_message_in_place_of_the_results
    end
  end

  scenario 'Using a postcode that cannot be geocoded' do
    given_reference_data_has_been_populated

    with_elastic_search! do
      with_fresh_index!
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_postcode_that_cannot_be_geocoded
    end

    VCR.use_cassette(:postcode_cannot_be_geocoded) do
      when_i_submit_the_search
    end

    with_elastic_search! do
      then_i_see_an_error_message_for_the_postcode_field
      and_i_see_a_message_in_place_of_the_results
    end
  end

  def given_reference_data_has_been_populated
    create(:other_advice_method, name: 'Phone', order: 1)
    create(:other_advice_method, name: 'Online', order: 2)
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @reading = create(:adviser, postcode: 'RG2 8EE', latitude: 51.428473, longitude: -0.943616, travel_distance: 100)
      @leicester = create(:adviser, postcode: 'LE1 6SL', latitude: 52.633013, longitude: -1.131257, travel_distance: 650)
      @glasgow = create(:adviser, postcode: 'G1 5QT', latitude: 55.856191, longitude: -4.247082, travel_distance: 10)

      @missing = create(:firm, in_person_advice_methods: []) do |firm|
        create(:adviser, firm: firm, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def and_i_am_on_the_results_page_after_a_previous_search
    landing_page.load
    landing_page.in_person.tap do |f|
      f.postcode.set 'RG2 9FL'
      f.search.click
    end

    expect(results_page).to be_displayed
  end

  def and_i_clear_any_filters_from_the_previous_search
    results_page.search_form.tap do |f|
      f.face_to_face.set false
      f.phone_or_online.set false

      f.postcode.set nil
      f.phone.set false
      f.online.set false

      f.retirement_income_products.set false
      f.pension_pot_size.set SearchForm::ANY_SIZE_VALUE
      f.pension_transfer.set false
      f.options_when_paying_for_care.set false
      f.equity_release.set false
      f.inheritance_tax_planning.set false
      f.wills_and_probate.set false
    end
  end

  def and_i_select_face_to_face_advice
    results_page.search_form.face_to_face.set true
  end

  def and_i_enter_a_valid_postcode
    results_page.search_form.postcode.set 'RG2 9FL'
  end

  def and_i_enter_an_invalid_postcode
    results_page.search_form.postcode.set 'B4D'
  end

  def and_i_enter_a_postcode_that_cannot_be_geocoded
    results_page.search_form.postcode.set 'ZZ1 1ZZ'
  end

  def when_i_submit_the_search
    results_page.search_form.search.click
  end

  def then_i_see_firms_that_cover_my_postcode
    expect(results_page).to be_displayed
    expect(results_page.firms).to be_present
  end

  def then_i_see_an_error_message_for_the_postcode_field
    expect(results_page).to have_errors
  end

  def and_i_see_a_message_in_place_of_the_results
    expect(results_page.incorrect_criteria_message).to be_present
  end
end
