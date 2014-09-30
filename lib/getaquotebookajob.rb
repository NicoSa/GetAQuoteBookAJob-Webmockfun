require 'sinatra'
require 'yaml'
require 'json'
require 'httparty'
require 'pry'
require 'shotgun'

def request_url
  yml = YAML::load(File.open('config/properties.yml'))
  yml['REQUEST_URL']
end

def token
  yml = YAML::load(File.open('config/properties.yml'))
  yml['TOKEN']
end

def request_headers(token)
  { 'Authorization' => 'Bearer ' + token }
end

def quote_body(pickup_location, delivery_location)
  {
    "quote_collection" => {
      "channel" =>          "pos",
      "page"    =>             "product",
      "session_id"  =>       "example123",
      "customer_id"  =>      "cookieuuid",
      "basket_value" =>     1999,

      "pickup_store_id" =>  "",

      "pickup_location" => {
        "address" => {
          "postcode" => pickup_location
        }
      },

      "delivery_location" => {
        "address" => {
          "postcode" => delivery_location
        }
      },

      "products" => [
        {
          "id" => "item1",
          "name" => "Item One",
          "description" => "Large Box if Squirrels",
          "url" => "http =>//squirrelandy.com/large_box_of_squirrels.html",
          "length" => 20,
          "width" => 15,
          "height" => 10,
          "weight" => 10,
          "quantity" => 1,
          "price" => 999
        }
      ],

      "contact" => {
        "name" =>  "Sharky McShovel",
        "email" => "Sharky@sharkmail.com",
        "phone" => "07840536666"
      }
    }
  }
end


def booking_body(pickup_location, delivery_location)
  {
    "booking" => {
      "quote_id" => "1a2b3c-asap",
      "merchant_booking_reference" => "YOUR_REF",
      "card_type" => "visa",
      "card_last_4_digits" => "9876",
      "payment_reference" => "1234567",
      "gift_wrap" => "false",

      "pickup_location" => {
        "address" => {
          "name" =>            "Gary Day",
          "company_name" =>    "Acme",
          "line_1" =>          "The Arches",
          "line_2" =>          "Bethnal Green",
          "city" =>            "London",
          "county_or_state" => "",
          "country" =>         "GB",
          "postcode" =>        pickup_location
        },

        "notes" => "proceed directly to the till",

        "contact" => {
          "name" =>  "Gary",
          "email" => "gary@acme.com",
          "phone" => "07840539999"
        }
      },

      "delivery_location" => {
        "address" => {
          "name" =>            "John Smith",
          "company_name" =>    "A1 Ltd",
          "line_1" =>          "12 My St",
          "line_2" =>          "Aborough",
          "city" =>            "London",
          "county_or_state" => "Essex",
          "country" =>         "GB",
          "postcode" =>        delivery_location
        },

        "notes" => "vicious dog",

        "contact" => {
          "name" =>  "Jane Jones",
          "email" => "janejones@a1ltd.com",
          "phone" => "07840536666"
        }
      }
    }
  }

end


get '/quote' do
  erb :get_a_quote
end

post '/quote' do
  pickup_location, delivery_location = params['pickup_location'], params['delivery_location']
  @body = quote_body(pickup_location, delivery_location)
  response = HTTParty.post("#{request_url}/quote_collections", :body => @body.to_json, :headers =>request_headers(token))
  @quote_collection = JSON.parse(response.body)
  @best_quote_delivery_text = @quote_collection['quote_collection']['best_quote']['delivery_promise_text']
  erb :delivery_promise
end

post '/booking' do
  pickup_location, delivery_location = params['pickup_location'], params['delivery_location']
  response = HTTParty.post("#{request_url}/bookings", :body => @booking.to_json, :headers => request_headers(token) )
  erb :booked
end
