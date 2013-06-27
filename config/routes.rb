
Finspweb::Application.routes.draw do

  devise_for :users

  resources :versions, :except => [:edit, :update] do
    member do
      get  'extract'
      post 'transform'
      put  'deactivate'
      get  'folder_exists'
      get  'download_archive'
      post 'save_mapping'
    end
    get 'search', :on => :collection
  end

  match "home/help" => "home#help"

  root :to => "home#index"
end
