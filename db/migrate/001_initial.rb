class Initial < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title
      t.string :link
      t.string :image_url
      t.integer :category_id
      t.timestamps
    end

    create_table :categories do |t|
      t.string :name
    end

    create_table :applicants do |t|
      t.string :email
    end
  end

  def self.down
    drop_table :categories
    drop_table :products
    drop_table :applicants
  end
end
