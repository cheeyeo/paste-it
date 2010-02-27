ActionController::Routing::Routes.draw do |map|
  
  map.resources :snippets, :collection=>{:update_cat => :get, :search => :get}, :member=>{:download=>:get}
  
  map.connect ':permalink', 
          :controller => 'snippets',
    			:action => 'show',
    			:filter => 'permalink'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
