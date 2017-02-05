require 'rails_helper'

# The problem: this is not backed by a DB, so I need to prepare and restore status
# as I proceed with tests. Is this good practice? #TODO

RSpec.describe CartController, type: :controller do

  let(:product_id) {107598}

  describe "PATCH #add" do
    after(:each) do
      patch :remove, params: { cart: { product_id: product_id } }
    end

    it "returns http success" do
      patch :add, params: { cart: { product_id: product_id, quantity: 1 } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    before(:each) do
      # add a product before testing
      patch :add, params: { cart: { product_id: product_id, quantity: 1 } }
    end

    after(:each) do
      patch :remove, params: { cart: { product_id: product_id } }
    end

    it "returns http success" do
      patch :update, params: { cart: { product_id: product_id, quantity: 3 } }
      expect(response).to have_http_status(:redirect)
    end
  end


  describe "PATCH #remove" do
    before(:each) do
      # add a product before testing
      patch :add, params: { cart: { product_id: product_id, quantity: 1 } }
    end

    it "returns http success" do
      patch :remove, params: { cart: { product_id: product_id } }
      expect(response).to have_http_status(:redirect)
    end
  end
end
