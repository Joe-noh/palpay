class PaypalsController < ApplicationController
  def create
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
    @token = params[:token]
    @payer_id = params[:PayerID]

    @get_express_checkout = api.build_get_express_checkout_details({
      Token: @token
    })

    @get_express_checkout_details_response = api.get_express_checkout_details(@get_express_checkout)
  end

  def execute
    @do_express_checkout_payment = api.build_do_express_checkout_payment({
      DoExpressCheckoutPaymentRequestDetails: {
        PaymentAction: "Sale",
        Token: params[:token],
        PayerID: params[:payer_id],
        PaymentDetails: [{
          OrderTotal: {
            currencyID: "JPY",
            value: 300
          }
        }]
      }
    })

    @do_express_checkout_payment_response = @api.do_express_checkout_payment(@do_express_checkout_payment)

    if @do_express_checkout_payment_response.success?
      details = @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails
      p details
    else
      errors = @do_express_checkout_payment_response.Errors
      p errors
    end
  end

  private

  def api
    @api ||= PayPal::SDK::Merchant::API.new
  end
end
