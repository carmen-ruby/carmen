require 'carmen'

module Carmen
  
  class Railtie < Rails::Railtie
    if defined? Rails::Railtie
      require 'rails'
      
      class Railtie < Rails::Railtie
        config.after_initialize do
          require 'carmen/action_view_helpers'
        end
      end
    end
    
  end
end