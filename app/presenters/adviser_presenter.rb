class AdviserPresenter
  MAPPED_FIELDS = %i[
    name
    postcode
    range
    qualification_ids
    accreditation_ids
    firm
  ].freeze
  UNMAPPED_FIELDS = %i[distance].freeze

  attr_reader(*MAPPED_FIELDS)
  attr_accessor(*UNMAPPED_FIELDS)

  def initialize(object)
    @object = object

    MAPPED_FIELDS.each do |field|
      instance_variable_set("@#{field}", object[field.to_s])
    end
  end

  def location
    Location.new(*object['_geoloc'].values)
  end

  private

  attr_reader :object
end
