class CreateDbSessionStores < ActiveRecord::Migration
  def change
    create_table :db_session_stores do |t|
      t.string :serialized_data

      t.timestamps
    end
  end
end
