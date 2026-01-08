Rails.application.routes.draw do
  root "static#index"
  get "boba_tea_menu" => "static#boba_tea_menu"
  get "/sitemap.xml", to: "sitemaps#index", defaults: { format: "xml" }
  get "gallery" => "static#gallery"
  get "all_about_sip" => "static#all_about_sip"
  get "dashboard_home" => "dashboard#index"

  resources :passwords, controller: "clearance/passwords", only: [ :create, :new ]
  resource :session, controller: "clearance/sessions", only: [ :create ]

  resources :users, controller: "clearance/users", reload: false, only: [] do
    resource :password, controller: "clearance/passwords", only: [ :edit, :update ]
  end
end
