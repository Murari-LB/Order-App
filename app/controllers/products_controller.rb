class ProductsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :get_product, only: [:edit, :update, :destroy, :show]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end  

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, :notice=> 'Product was successfully created.'
    else
      redirect_to new_product_path, :alert=> 'Error! Please try again'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @order = Order.where("product_id = ?", params[:id])
    if @order.count > 0
      redirect_to products_path, :alert => 'Cannot delete product while its order exists.'
    else  
      if @product.destroy
        redirect_to products_path, :notice => 'Product was successfully deleted.'
      else
        redirect_to products_path, :alert => 'Error! Please try again'
      end
    end  
  end


  private
  
    def product_params
      params.require(:product).permit(:product_name, :product_details, :price)
    end

    def get_product
      @order = Product.find(params[:id])
    end

end
