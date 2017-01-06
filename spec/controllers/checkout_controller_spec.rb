require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do

  describe "POST #shipment" do
    it "returns http success" do
      post :shipment
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #address" do
    it "returns http success" do
      post :shipment
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #payment" do
    it "returns http success" do
      post :payment
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #review" do
    it "returns http success" do
      post :review
      expect(response).to have_http_status(:success)
    end
  end

end
