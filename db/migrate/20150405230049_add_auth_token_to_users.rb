class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    create_table :remember_me_tokens do |t|
      t.string :value, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
