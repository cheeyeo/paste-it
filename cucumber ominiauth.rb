# sets the test mode to true 

OmniAuth.config.test_mode = true 

#the symbol passed to mock_auth is the same as the name of the provider set up in the omniauth initializer 

OmniAuth.config.mock_auth[:twitter] = { 
"provider"=>"twitter", "uid"=>"123456", 
"credentials" => {"token" => "mytoken","secret" => "mysecret"}, 
"extra" => { "user_hash"=>{"email"=>"test@xxxx.com", "first_name"=>"Test", "last_name"=>"User", "name"=>"Test User"} }
 } 