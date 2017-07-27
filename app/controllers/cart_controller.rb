class CartController < ApplicationController

	before_action :authenticate_user!, only: [:checkout]

  def add_to_cart

    @order = current_order

  	line_item = @order.line_items.new(product_id: params[:product_id], quantity: params[:quantity])
  	if line_item.quantity.nil?
  		flash[:error] = "Select Any Quantity for the product #{line_item.product.name} you want to buy!" 
  		line_item.destroy
  		redirect_to root_url
  	else
      @order.save
      session[:order_id] = @order.id
  		line_item.update(line_item_total: (line_item.quantity * line_item.product.price))
  		redirect_to root_url
  	end
  end

  def delete_from_cart

  	line_item = LineItem.find(params[:line_item_id])
  	line_item.destroy

  	redirect_to view_order_path

  end

  def cancel_checkout
    order = Order.find(params[:order_id])
    session[:order_id] = nil
    order.destroy

    redirect_to root_url
  end

  def view_order
  	@line_items = current_order.line_items
  end

  def checkout
  	line_items = current_order.line_items

  	if line_items.empty? 

  		redirect_to root_url
  	else

      @order = current_order
      @order.update(user_id: current_user.id, subtotal: 0)

	  	line_items.each do |line_item|

	  		if @order.order_items[line_item.product_id].nil?
	  			@order.order_items[line_item.product_id] = line_item.quantity
	  		elsif @order.order_items[line_item.id] == line_item.id
	  			@order.order_items[line_item.product_id] += line_item.quantity
	  		end

	  		@order.subtotal += line_item.line_item_total
	 
	  	end
      
	  	@order.save

	  	@order.update(sales_tax: (@order.subtotal * 0.08))
	  	@order.update(grand_total: (@order.sales_tax + @order.subtotal))

	 end

  end

  def order_complete
    # Amount in cents
    line_items = current_order.line_items

    @order = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Tech Talent Store Customer',
      :currency    => 'usd'
    )

    session[:order_id] = nil
    line_items.destroy_all

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_url
    end

end












