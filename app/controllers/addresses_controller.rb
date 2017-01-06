class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    Address.create(address_params)

    redirect_back(fallback_location: root_path)
  end

  def edit
    @address = Address.find(params[:id])
    @address.update!(address_params)

    redirect_back(fallback_location: root_path)
  end

  def destroy
    if Address.delete(params[:id])
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end

  private

  def address_params
    params.require(:address).permit!
  end

end
