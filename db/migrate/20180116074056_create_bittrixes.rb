class CreateBittrixes < ActiveRecord::Migration[5.1]
  def change
    create_table :bittrixes do |t|
      t.float :sell_price
      t.float :buy_price
      t.timestamps
    end
  end
end
