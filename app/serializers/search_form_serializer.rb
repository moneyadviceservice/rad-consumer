class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    [].tap do |options|
      if object.phone_or_online?
        options << 'registered_name'
      end

      if object.face_to_face?
        options << {
          _geo_distance: {
            'advisers.location': object.coordinates.reverse,
            order: 'asc',
            unit: 'miles'
          }
        }
      end
    end
  end

  def query
    {
      filtered: {
        filter: {
          bool: {
            must: build_filters
          }
        },
        query: {
          bool: {
            must: build_queries
          }
        }
      }
    }
  end

  private

  def build_filters
    [].tap do |filters|
      filters << { in: { other_advice_methods: object.remote_advice_method_ids } } if object.phone_or_online?
    end
  end

  def build_queries
    investment_size_queries.tap do |expression|
      expression.push(*postcode_queries)        if object.face_to_face?
      expression.push(*types_of_advice_queries) if object.types_of_advice?
    end
  end

  def postcode_queries
    [
      {
        match: {
          postcode_searchable: true
        }
      },
      {
        nested: {
          path: 'advisers',
          filter: {
            bool: {
              must: {
                geo_shape: {
                  range_location: {
                    relation: 'intersects',
                    shape: {
                      type: 'point',
                      coordinates: object.coordinates.reverse
                    }
                  }
                }
              },
              should: {
                geo_distance: {
                  distance: '750miles',
                  location: object.coordinates.reverse
                }
              }
            }
          }
        }
      }
    ]
  end

  def investment_size_queries
    [].tap do |filters|
      if object.retirement_income_products?
        unless object.any_pension_pot_size?
          filters << { match: { investment_sizes: object.pension_pot_size } }
        end
      end
    end
  end

  def types_of_advice?
    object.types_of_advice.present?
  end

  def types_of_advice_queries
    object.types_of_advice.map { |type| { range: { type => { gt: 0 } } } }
  end
end
