module UsersHelper
  def validate_class(form_type, field)
    text = 'form-control'
    if @resource
      error_massages = @resource.errors.messages 
      if error_massages[form_type] && !error_massages[field].empty?
        text << ' error'
      end
    end
    text
  end

  def show_errors(obj, form_type)
    string = '' 
    #byebug
    error_massages = obj ? obj.errors.messages : nil
    if error_massages && error_massages[form_type] == true
      error_massages.keys.each do |key, _value|
        #byebug
        string << '<span class="error_message">'
        string << "#{key} - " << error_massages[key][0] if key != form_type
        string << '</span><br>'
      end
      string << "<div id='shipping_error' class='has_errors'></div>" if error_massages[:shipping_form] == true
    end
    string.html_safe
  end

  def clear_obj
    current_user.errors.messages.except!(:name_email_firstname, :email, :lastname, :firstname)
  end

  #def show_flashes(form_type)
    #@string = ''
    #if flash['error'] && flash['error'][form_type]
      #flash['error'].keys.each do |key, _value|
        #@string << '<span class="error_message">'
        #@string << "#{key} - " << flash['error'][key][0] if key != form_type
        #@string << '</span><br>'
      #end
      #@string << "<div id='shipping_flashes' class='has_flashes'></div>" if flash['error']['shipping_form'] == true
    #end
    #@string.html_safe
  #end

end
