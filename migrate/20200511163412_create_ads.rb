Sequel.migration do
  up do
    create_table(:ads) do
      primary_key :id
      String :title, null: false
      String :description, null: false, text: true
      String :city, null: false
      Float :lat
      Float :lon
      Bignum :user_id, null: false, index: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    drop_table(:ads)
  end
end
