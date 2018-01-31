class LineItemsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy add_quantity reduce_quantity]

  def create
    # Find associated product and current cart
    chosen_product = Product.find(params[:product_id])
    current_cart = @current_cart

    # If cart already has this product then find the relevant line_item and iterate quantity otherwise create a new line_item for this product
    if current_cart.products.include?(chosen_product)
      # Find the line_item with the chosen_product
      @line_item = current_cart.line_items.find_by(product_id: chosen_product)
      # Iterate the line_item's quantity by one
      @line_item.quantity += 1
    else
      @line_item = LineItem.new
      @line_item.cart = current_cart
      @line_item.product = chosen_product
      # @line_item.order = Order.first
      @line_item.quantity = 1
    end

    # redirect_to cart_path(@current_cart)
    # redirect_back(fallback_location: root_url)

    respond_to do |format|
      if @line_item.save!
        format.js
        # below is a second way without creating ``
        # format.js { render :js => "alert('hi')" }
      else
        format.html { render :new, notice: 'Error adding product to basket!' }
      end
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_back(fallback_location: @current_cart)
  end

  def add_quantity
    @line_item = LineItem.find(params[:id])
    @line_item.quantity += 1
    @line_item.save
    redirect_back(fallback_location: @current_cart)
  end

  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
      @line_item.save
      redirect_back(fallback_location: @current_cart)
    elsif @line_item.quantity == 1
      destroy
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:quantity, :product_id, :cart_id)
  end
end
