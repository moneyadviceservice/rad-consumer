class RemoteSearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    'registered_name'
  end

  def query
    {
      'filtered' => {
        'filter' => {
          'in' => {
            'other_advice_methods' => remote_advice_method_ids
          }
        }
      }
    }
  end

  private

  def remote_advice_method_ids
    object.advice_methods.select(&:present?)
  end
end
