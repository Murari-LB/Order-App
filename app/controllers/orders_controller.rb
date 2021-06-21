class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :get_order, only: [:update, :edit, :destroy, :show]

  def index
    if current_user.admin?
      if params[:filter] == "true"
        @orders = Order.all.where(user_id: params[:user_id], order_status: params[:order_status])
      else
        @orders = Order.all
      end
    else
      @orders = Order.where(user_id: current_user.id)
    end
    @users = User.all.pluck(:username, :id)
  end

  def show
  end

  def new
    @order = Order.new
    @product = Product.all
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to orders_path, :notice=> 'Order was successfully created.'
    else
      redirect_to new_order_path, :alert=> 'Error! Please try again'
    end
  end

  def edit
    @product = Product.all
  end

  def update
    if @order.update(order_params)
      @user = User.find(@order.user_id)
      UserMailer.status_email(@user, @order).deliver
      redirect_to orders_path, :notice=> 'Order was successfully updated.'
    else
      redirect_to new_order_path, :alert=> 'Error! Please try again'
    end
  end

  def destroy
    if @order.destroy
      redirect_to orders_path, :notice => 'Order was successfully deleted.'
    else
      redirect_to orders_path, :alert => 'Error! Please try again'
    end
  end

  private

    def order_params
      params.require(:order).permit(:name, :phone, :address, :delivery_date, :product_id, :payment_option, :quantity, :order_status, :user_id)
    end

    def get_order
      @order = Order.find(params[:id])
    end

end
