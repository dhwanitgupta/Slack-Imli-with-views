class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender_id
      t.string :reciever_id
      t.text :content

      t.timestamps null: false
    end
  end
end
