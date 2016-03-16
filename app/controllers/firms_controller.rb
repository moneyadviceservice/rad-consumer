class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(@search_form.to_query)

    @firm  = result.firms.first
    @offices = Geosort.by_distance(@search_form.coordinates, @firm.offices)
    @advisers = sort_advisers(@search_form, @firm.advisers)

    @latitude, @longitude = @search_form.coordinates

    store_recently_visited_firm
  end

  private

  def store_recently_visited_firm
    url = firm_path(
      params[:id], search_form: {
        advice_method: params['search_form']['advice_method'],
        pension_pot_size: params['search_form']['pension_pot_size'],
        postcode: params['search_form']['postcode']
      }
    )
    visited_firms = RecentlyVisitedFirms.new(session)
    visited_firms.store(@firm, url)
  end

  private

  def sort_advisers(search_form, advisers)
    if search_form.face_to_face?
      Geosort.by_distance(search_form.coordinates, advisers)
    else
      advisers.sort { |a1, a2| a1.name <=> a2.name }
    end
  end
end
