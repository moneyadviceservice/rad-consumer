module Filters
  module PensionPot
    ANY_SIZE_VALUE = 'any'.freeze

    attr_accessor :pension_pot_size

    def options_for_pension_pot_sizes
      I18n.t('investment_size.ordinal').map do |id, name|
        [name, id.to_s]
      end.unshift(
        [I18n.t('search_filter.pension_pot.any_size_option'), ANY_SIZE_VALUE]
      )
    end

    def any_pension_pot_size?
      pension_pot_size && pension_pot_size == ANY_SIZE_VALUE
    end
  end
end
