class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :date,          null: false
      t.time :time,          null: false
      t.string :description, null: false
      t.decimal :amount,     null: false
      t.text :comment
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
