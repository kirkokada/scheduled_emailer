class AddSentToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :sent, :boolean, default: false
  end
end
