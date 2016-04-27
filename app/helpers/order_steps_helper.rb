module OrderStepsHelper


  def validate_checkout_class(object, form_type, error_field, data = false)
    #byebug  
    if object[form_type].errors.messages.any?
      #byebug
      if object[form_type].errors.messages[error_field] && object[form_type].errors.messages[error_field] != []
        data ? "border: 1px solid red" : "form-control error"
      else
        "form-control" unless data
      end
    else
      "form-control" unless data
    end
  end


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
