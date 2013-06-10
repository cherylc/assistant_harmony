AssistantHarmony::Application.routes.draw do
  get   "/register"                => "sessions#new",    as: :register
  match "/auth/:provider/callback" => "sessions#create", as: :register_callback

  resource :profile, only: [:show, :update] do
    resources :assignments, only: [:index, :show, :create, :destroy] do
      member do
        get :schedule
      end
    end

    resources :meetings, only: [] do
      member do
        get :reject
        get :schedule
      end
    end

    resources :calendars, only: [:subscribe] do
      get :subscribe
    end

    get :load
  end

  root to: "profiles#show"
end
