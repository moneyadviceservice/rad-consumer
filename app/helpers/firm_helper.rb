module FirmHelper
  def firm_has_other_services?(firm)
    firm.ethical_investing_flag || firm.sharia_investing_flag ||
      firm.workplace_financial_advice_flag || firm.non_uk_residents_flag
  end

  def firm_language_list(language_codes)
    language_codes
      .map(&LanguageList::LanguageInfo.method(:find))
      .map(&:common_name)
      .sort
  end

  def type_of_advice_list_item(firm, type, style_classes)
    return unless firm.includes_advice_type?(type)

    content_tag :li,
                I18n.t("firms.show.panels.firm.services.types_of_advice.#{type}"),
                class: style_classes
  end

  def closest_adviser_text(distance)
    I18n.t('search.result.miles_away', distance: format('%.1f', distance.to_f))
  end

  def minimum_pot_size_text(firm_result)
    all_lowest = t('investment_size.ordinal').keys.min.to_s.to_i
    firm_lowest = firm_result.investment_sizes.first
    return t('investment_size.no_minimum') if firm_lowest == all_lowest

    t("investment_size.ordinal.#{firm_lowest}")
  end

  def minimum_fixed_fee(firm_result)
    number_to_currency firm_result.minimum_fixed_fee, unit: '£', precision: 0
  end

  def ensure_external_link_has_protocol(link)
    if link =~ /^https?/
      link
    else
      "http://#{link}"
    end
  end

  def recently_visited_firms
    session[:recently_visited_firms]
  end

  def trim_postcode(postcode)
    postcode.split.first
  end
end
