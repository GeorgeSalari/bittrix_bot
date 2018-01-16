Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'bittrixes#bitrix_api_respons'
  get 'bitrix_api_respons' => 'bittrixes#bitrix_api_respons'
  post 'place_buy_order' => 'bittrixes#place_buy_order'
end
