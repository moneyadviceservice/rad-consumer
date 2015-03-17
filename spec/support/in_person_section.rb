class InPersonSection < SitePrism::Section
  element :postcode, '.t-postcode'
  element :search, '.button--primary'

  element :pension_pot, '#search_form_retirement_income_products'
  element :pension_pot_size, '#search_form_pension_pot_size'
  element :pension_pot_transfer, '#search_form_pension_transfer'

  element :options_when_paying_for_care, '#search_form_options_when_paying_for_care'
  element :equity_release, '#search_form_equity_release'
  element :inheritance_tax_planning, '#search_form_inheritance_tax_planning'
  element :wills_and_probate, '#search_form_wills_and_probate'

  def invalid_postcode?
    has_css?('.field_with_errors .t-postcode')
  end
end
