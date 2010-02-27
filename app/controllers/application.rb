# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e8272c8a8184e79af98be96454ea3842'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def render_cached(key, expiration, render_options)
    return unless perform_caching
    if should_cache?
      combined_key = [
        'controller',
        controller_name,
        action_name,
        params[:format] || 'html',
        key
      ].join(':')
      output = Rails.cache.get(combined_key, expiration) do
        render_to_string render_options
      end
      render :text => output
    else
      render render_options
    end
  end
  
  
  
  
  
end
