Profile::Application.routes.draw do
  get "micro_posts/refresh"
  get "micro_posts/destroy_all"
  match 'micro_posts/feed' => 'micro_posts#feed', :defaults => { :format =>'rss' }, 
      :as => :micro_posts_feed
  resources :micro_posts

  get "home/index"

  get "entries/new_blog", :as => :new_blog_entry
  get "entries/new_github", :as => :new_github_entry
  get "entries/new_auto", :as => :new_auto_entry
  match "/entries/retry/:id" => "entries#retry", :as => :retry_entry, :via => :get
  resources :entries

  devise_for :users
  resources :users, :only => [:index, :show]  do 
    member do
      get :following, :followers, :entry
      get :posts
      post :refresh_posts
      match "/refresh_progress/:job_id" => "users#refresh_progress", :as => :refresh_progress, :via => :post
    end
  end
  
  resources :relationships, :only => [:create, :destroy]

  get 'settings/profile'
  put 'settings/profile_p'
  get 'settings/password'
  put 'settings/password_p'

  match "/about" => "home#about", :as => :about, :via => :get
  match "/stat" => "home#stat", :as => :stat, :via => :get
  match "/intro" => "home#intro", :as => :intro, :via => :get
  match "/story" => "home#story", :as => :story, :via => :get
  match "/suggest" => "home#suggest", :as => :suggest, :via => :get
  match "/update_log" => "home#update_log", :as => :update_log, :via => :get

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#intro'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
