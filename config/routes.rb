Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  root 'static#index'
  get 'boba_tea_menu' => 'static#boba_tea_menu'
  get '/sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  get 'gallery' => 'static#gallery'
  get 'all_about_sip' => 'static#all_about_sip'
end
