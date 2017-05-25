module Filters
  module AdviceMethod
    ADVICE_METHOD_FACE_TO_FACE     = 'face_to_face'
    ADVICE_METHOD_PHONE_OR_ONLINE  = 'phone_or_online'
    ADVICE_METHOD_FIRM_NAME_SEARCH = 'firm_name_search'
    NONE                           = 'none'

    attr_accessor :advice_method, :postcode, :coordinates, :firm_name

    def firm_name_search?
      advice_method == ADVICE_METHOD_FIRM_NAME_SEARCH
    end

    def face_to_face?
      advice_method == ADVICE_METHOD_FACE_TO_FACE
    end

    def phone_or_online?
      advice_method == ADVICE_METHOD_PHONE_OR_ONLINE
    end

    def coordinates
      @coordinates ||= Geocode.call(postcode)
    end

    def postcode
      @postcode if face_to_face?
    end

    def remote_advice_method_ids
      phone_or_online? ? OtherAdviceMethod.all.map(&:id) : []
    end

    private

    def geocode_postcode
      return if postcode =~ /\A[A-Z\d]{1,4} ?[A-Z\d]{1,3}\z/ && coordinates
      errors.add(:postcode, I18n.t('search.errors.geocode_failure'))
    end

    def upcase_postcode
      postcode.try(:upcase!)
    end
  end
end