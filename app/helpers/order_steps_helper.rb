module OrderStepsHelper


  #def validate_class(form_type, flash_field)
    #if flash["error"] != nil
      #if flash["error"][form_type] && flash["error"][flash_field] != nil
        #{}"form-control error"
     # else
        #{}"form-control"
      #end
    #else
      #{}"form-control"
    #end
  #end


  def checkbox_state(bool = false)
    if @order_steps_form['shipping_address'].errors.messages.any?
      bool ? false : '0'
    else
      bool ? true : '1'
    end
  end


  def show_errors(form_type)

    @string = ''
    if @order_steps_form[form_type].errors.messages.any?
      @order_steps_form[form_type].errors.messages.each do |error_message|
        if error_message.second.first.to_s != ''
          @string << "<div style='color: red'>" + error_message.first.to_s
          @string << " - " + error_message.second.first.to_s + " </div>"
        end
      end
    end
    @string << '<br>'
    @string.html_safe
  end
end
