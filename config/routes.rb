Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :reports, only: :index do
      collection do
        get :products_out_stock
      end
    end
  end
end
