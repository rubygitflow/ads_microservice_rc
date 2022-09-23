class Ad < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer

  def validate
    super
    validates_presence [:title, :description, :city, :user_id, :created_at, :updated_at]
  end
end
