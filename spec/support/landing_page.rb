require_relative 'in_person_section'
require_relative 'remote_section'

class LandingPage < SitePrism::Page
  set_url '/en'
  set_url_matcher %r{/(en|cy)}

  section :in_person, InPersonSection, '.t-in-person'
  section :remote, RemoteSection, '.t-remote'
end
