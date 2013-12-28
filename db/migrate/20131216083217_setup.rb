class Setup < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string  :name
      t.timestamps
    end

    (1..10).each do |i|
      Test.create!(:name => i.to_s)
    end
  end

  def self.down
    drop_table :test
  end
end
