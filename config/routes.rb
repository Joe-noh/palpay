Rails.application.routes.draw do
  get '/' => 'pages#show'

  get  '/payment' => 'paypals#show'
  post '/payment' => 'paypals#create'
  post '/payment/execute' => 'paypals#execute'
end
