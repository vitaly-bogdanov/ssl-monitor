class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string :name, null: false, uniqueness: true
      t.string :status, default: 'всё хорошо'
      t.string :status_message, default: ''
      t.integer :port, default: 80
      t.string :error_message, default: ''
      t.timestamps
    end
  end
end
