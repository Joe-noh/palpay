class PaypalsController < ApplicationController
  def create
    api = PayPal::SDK::Merchant::API.new

    @set_express_checkout = api.build_set_express_checkout(
      SetExpressCheckoutRequestDetails: {
        ReturnURL: "http://localhost:3000/payment?nonce=123",
        CancelURL: "http://localhost:3000/",
        PaymentDetails: [{
          OrderTotal: {
            currencyID: "JPY",
            value: params[:price].inject(:+)
          },
          ItemTotal: {
            currencyID: "JPY",
            value: params[:price].inject(:+)
          },
          ShippingTotal: {
            currencyID: "JPY",
            value: "0"
          },
          TaxTotal: {
            currencyID: "JPY",
            value: "0"
          },
          PaymentDetailsItem: [{
            Name: params[:name][0],
            Quantity: 1,
            Amount: {
              currencyID: "JPY",
              value: params[:price][0]
            },
            ItemCategory: "Physical"
          }],
          PaymentAction: "Sale"
        }]
      }
    )

    @set_express_checkout_response = api.set_express_checkout(@set_express_checkout)

    redirect_to api.express_checkout_url(@set_express_checkout_response)
  end

  def show
  end

  def execute
  end
end
