module UsersHelper

  def validate_class(form_type, flash_field)
    if flash["error"] != nil
      if flash["error"][form_type] && flash["error"][flash_field] != nil
        "form-control error"
      else
        "form-control"
      end
    else
      "form-control"
    end
  end

  def show_flashes(form_type)
    @string = ''
    if flash["error"] != nil && flash["error"][form_type]
      flash['error'].keys.each do |key, value|
        @string << "<span class=\"error_message\">" 
        if key != form_type
          @string << "#{key} - " << flash['error'][key][0] 
        end
        @string << "</span><br>"
      end
      @string << "<div id='shipping_flashes' class='has_flashes'></div>" if flash["error"]['shipping_form'] == true
    end
    @string.html_safe
  end
end