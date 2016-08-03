class ChangeAddressService
  def initialize(order, bool, atributes)
    @order = order
    @bool  = bool
    @atributes = atributes
  end

  def call
    if @bool == 'true'
      if @order.billing_address && @order.shipping_address
        addresses_update
      else
        two_addresses_create
      end
    else
      if @order.billing_address
        addresses_update
      else
        addresses_create
      end
    end
  end

  private

  def two_addresses_create
    @order.create_billing_address(@atributes[:billing_address])
    @order.create_shipping_address(@atributes[:billing_address])
  end

  def addresses_create
    @order.create_billing_address(@atributes[:billing_address])
    @order.create_shipping_address(@atributes[:shipping_address])
  end

  def addresses_update
    @order.billing_address.update(@atributes[:billing_address])
    @order.shipping_address.update(@atributes[:shipping_address])
  end

end