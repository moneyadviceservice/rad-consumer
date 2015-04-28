module ApplicationHelper
  def page_tag(tag_name)
    t("#{controller_name}.#{action_name}.#{tag_name}")
  end

  def search_filter_options(form, page_name)
    render partial: 'landing_page/search_filter_options', locals: { f: form, page_name: page_name }
  end

  def render_logo(id, kind)
    key = kind.to_s.titleize.constantize.friendly_name(id)

    unless key == 'ignored'
      info = t("search.accreditations.items.#{key}")
      link_to "glossary/##{key}", class: "accreditation t-#{kind}" do
        image_tag "#{key}.png", alt: info[:title], class: 'accreditation__img'
      end
    end
  end
end
