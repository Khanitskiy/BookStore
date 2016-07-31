class CurrentStepService
  def initialize(order)
    @order = order
  end

  def call
    @hash = { address: 0, delivery: 1, payment: 2, confirm: 3, complete: 4 }
    @hash.each do |variable|
      if variable.second > @order.step_number.to_i
        @hash.delete(variable.first)
      else
        @last_step = variable.first
      end
    end
    [@last_step, @hash]
  end

end