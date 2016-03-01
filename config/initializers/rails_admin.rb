RailsAdmin.config do |config|
  
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.authorize_with :cancan 
  #TODO add cancancan to rails_admin config

  config.model 'User' do
    edit do
      configure :facebook_image do
        visible do
          #user = User.find(params['id'])
          #user.provider == 'facebook'
          true
        end
      end
    end
  end

  #def get_params_id(original_url)
  #  uri_string = URI::parse(uri)
  #  id = uri_string.path.split('/')[3]
  #end

  #def original_url
  #  base_url + original_fullpath
  #end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
