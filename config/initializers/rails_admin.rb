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

  config.model 'Book' do
    list do
      field :title
      field :price
      field :in_stock
      #field :rating
      field :order_counter
      field :best_seller
      field :category
      include_all_fields
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

   config.excluded_models << OrderItem

  ['Author',
   'Book',
   'Category',
   'Cupon',
   'User', 
   'Order',
   'OrderItem', 
   'Rating'].each do |model_name|
    config.model model_name do

      if model_name == 'User'
        object_label_method do
          :custom_label_method
        end
      end
      
      exclude_fields :created_at, :updated_at

      exclude_fields(:credit_card,
                    :step_number) if model_name == 'Order'
    end
  end


  config.model 'Order' do
    edit do
      include_fields :state
      field :state, :enum do
        enum do
          init_state = bindings[:object].state
          bindings[:object].aasm.states(:permitted => true).map(&:name)
              .unshift(init_state)
        end
      end
    end
  end

end