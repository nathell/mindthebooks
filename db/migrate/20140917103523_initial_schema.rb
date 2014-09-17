# `rails generate model` creates one class per model, but I'd rather
# have one file with the definitions of the entire intial database
# schema, and subsequent alterations will be in their own files.

class InitialSchema < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash

      t.timestamps
    end

    create_table :cards do |t|
      t.integer :user_id
      t.string :number

      t.timestamps
    end

    create_table :card_infos do |t|
      t.integer :card_id
      t.string :cardholder
      t.string :charges

      t.timestamps
    end

    create_table :books do |t|
      t.integer :card_info_id
      t.integer :library_id
      t.string :title
      t.string :author
      t.date :due_date
      t.string :fine
      t.integer :renew_count

      t.timestamps
    end
  end
end
