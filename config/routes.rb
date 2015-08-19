Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :product_imports, only: :create
  end
end
