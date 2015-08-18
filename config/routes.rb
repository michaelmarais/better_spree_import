Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :product_imports, :only => [:new, :create]
  end
  get '/admin/orders/export_csv/' => 'admin/orders#export_csv', as: 'export_csv'
end
