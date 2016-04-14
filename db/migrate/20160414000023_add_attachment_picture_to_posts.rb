class AddAttachmentPictureToPosts < ActiveRecord::Migration
  def self.up
  	remove_column :posts, :picture
    change_table :posts do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :posts, :picture
    add_column :posts, :picture, :string
  end
end
