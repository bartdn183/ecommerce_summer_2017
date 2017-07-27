Rails.application.routes.draw do

  get 'your_orders' => 'orders#your_orders'

  post 'add_to_cart' => 'cart#add_to_cart'

  post 'order_complete' => 'cart#order_complete'

  post 'cancel_checkout' => 'cart#cancel_checkout'

  delete 'delete_from_cart' => 'cart#delete_from_cart'

  get 'view_order' => 'cart#view_order'

  get 'checkout' =>'cart#checkout'

  devise_for :users
  
  get 'categorical' => 'storefront#items_by_category'

  get 'branding' => 'storefront#items_by_brand'

  resources :categories
  resources :products

  root 'storefront#all_items'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
