class AddApplicationType < ActiveRecord::Migration
  def self.up
    add_column :applicants, :study, :string
  end

  def self.down
    remove_column :applicants, :study
  end
end