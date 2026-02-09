class CreateComments < ActiveRecord::Migration[8.0]
    def change
        unless table_exists?(:comments) or !table_exists?(:tasks)
            create_table :comments do |t|
                t.belongs_to :task, null: false, foreign_key: true
                t.belongs_to :user, null: false, foreign_key: true
                t.text :content, null: false
                t.timestamps
            end
        end
    end
end
