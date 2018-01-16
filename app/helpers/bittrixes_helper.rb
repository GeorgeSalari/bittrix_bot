module BittrixesHelper
  def calc_procent(sell, buy)
    (sell-buy)/(buy/100)
  end
end

