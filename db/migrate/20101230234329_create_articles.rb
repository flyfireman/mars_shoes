class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|

      t.integer :user_id

      t.string :title

      t.text :synopsis,:limit => 1000

      t.text :body,:limit => 20000

      t.boolean :published, :default => false

      t.datetime :published_at

      t.integer :category_id


      t.timestamps

    end
  end
  
  def self.down
    drop_table :articles
  end
end
