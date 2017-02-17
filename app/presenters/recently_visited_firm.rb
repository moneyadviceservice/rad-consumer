class RecentlyVisitedFirm < OpenStruct
  def self.map(recently_visited_firms)
    recently_visited_firms.map { |recently_visited_firm| new(recently_visited_firm) }
  end

  def translated_profile_path
    profile_path[I18n.locale.to_s]
  end

  def closest_adviser?
    face_to_face? && closest_adviser.to_f > 0
  end

  def phone_or_online_only?
    !face_to_face?
  end
end
