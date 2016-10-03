class CreateIdeas < ActiveRecord::Migration[5.0]
  def change
    create_table :ideas do |t|
      t.text :title
      t.text :body
      t.integer :quality, default: 0

      t.timestamps
    end
  end
end
