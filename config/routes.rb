Rails.application.routes.draw do
  root to: 'application#root'

  namespace :api, defaults: {format: :json} do

    resources :users, except: [:new, :edit, :destroy, :update]

    resource :session, only: [:create, :show, :destroy, :update]

    resources :subs, except: [:new, :edit]

    resources :posts, except: [:new, :edit] do
      post :upvote, on: :member
      post :downvote, on: :member
      post :clear_vote, on: :member
      member do
        resources :comments, except: [:new, :edit, :index] do
          post :upvote, on: :member
          post :downvote, on: :member
          post :clear_vote, on: :member
        end
      end
    end

  end

end
