RSpec.feature 'Results page, consumer requires advice on various topics in person',
              vcr: vcr_options_for_feature(:results_face_to_face_filter_for_other_advice_types) do
  let(:landing_page) { LandingPage.new }
  let(:results_page) { ResultsPage.new }

  scenario 'Filter for various types of advice' do
    with_elastic_search! do
      given_reference_data_has_been_populated
      and_firms_with_advisers_were_previously_indexed
      and_i_am_on_the_results_page_after_a_previous_search
      and_i_clear_any_filters_from_the_previous_search
      and_i_select_face_to_face_advice
      and_i_enter_a_valid_postcode 'RG2 9FL'
      and_i_indicate_i_need_advice_on_various_topics
      when_i_submit_the_search
      then_i_am_shown_firms_that_provide_the_selected_types_of_advice
      and_they_are_ordered_by_location
    end
  end

  def given_reference_data_has_been_populated
    create(:other_advice_method, name: 'Phone', order: 1)
    create(:other_advice_method, name: 'Online', order: 2)
  end

  def and_firms_with_advisers_were_previously_indexed
    with_fresh_index! do
      @first = create(:firm, retirement_income_products_flag: true, wills_and_probate_flag: true, registered_name: 'first')
      @leicester = create(:adviser, firm: @first, latitude: 52.633013, longitude: -1.131257)

      @second = create(:firm, retirement_income_products_flag: true, wills_and_probate_flag: true, registered_name: 'second')
      @glasgow = create(:adviser, firm: @second, latitude: 55.856191, longitude: -4.247082)

      @excluded = create(:firm, retirement_income_products_flag: true, registered_name: 'exluded')
      create(:adviser, firm: @excluded, latitude: 51.428473, longitude: -0.943616)

      #  This firm isn't strictly needed here. If something was wrong an extra result (this one)
      #  would appear and so it would break a results count test somewhere.
      create(:firm, retirement_income_products_flag: true, registered_name: 'extra') do |f|
        create(:adviser, firm: f, latitude: 51.428473, longitude: -0.943616)
      end
    end
  end

  def and_i_indicate_i_need_advice_on_various_topics
    results_page.search_form.retirement_income_products.set true
    results_page.search_form.wills_and_probate.set true
  end

  def then_i_am_shown_firms_that_provide_the_selected_types_of_advice
    expect(results_page).to be_displayed
    expect(results_page).to have_firms(count: 2)
  end

  def and_they_are_ordered_by_location
    ordered_results = [@first, @second].map(&:registered_name)

    expect(results_page.firm_names).to eql(ordered_results)
  end
end
