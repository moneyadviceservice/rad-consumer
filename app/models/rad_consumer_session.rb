class RadConsumerSession
  def initialize(store)
    @store = store
    @store[:recently_visited_firms] ||= []
  end

  def firms
    @store[:recently_visited_firms]
  end

  def search_results_url
    @store['most_recent_search_url']
  end

  def store(firm_result, profile_url, english_search_url, welsh_search_url)
    return if firm_already_present?(firm_result)
    firms.pop if firms.length >= 3
    firms.unshift('id' => firm_result.id,
                  'name' => firm_result.name,
                  'closest_adviser' => firm_result.closest_adviser,
                  'face_to_face?' => firm_result.in_person_advice_methods.present?,
                  'profile_url' => profile_url)

    @store['most_recent_search_url'] = {
      'en' => english_search_url,
      'cy' => welsh_search_url
    }
  end

  private

  def firm_already_present?(firm_result)
    firms.any? { |firm_hash| firm_result.id == firm_hash['id'] }
  end
end
