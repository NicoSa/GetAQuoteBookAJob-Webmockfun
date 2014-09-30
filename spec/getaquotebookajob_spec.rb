require 'spec_helper'

describe 'getaquotebookajob', type: :feature do

	let(:body) {
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
						"postcode" => "N1 5SU"
					}
				},

				"delivery_location" => {
					"address" => {
						"postcode" => "E10 6LL"
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
	}

	let(:body_collection) {
		{
			"quote_collection"=>{
				"id"=>"542a83b4e4b0499daf04a0d5",
				"created_at"=>"2014-09-30T11:19+01:00",
				"time_zone"=>"Europe/London",
				"distance"=>5.1,
				"no_coverage"=>false,
				"shop_and_pay_by_card"=>false,
				"best_quote"=>{
					"id"=>"542a83b4e4b0499daf04a0d5-1412120072",
					"merchant_price"=>2440,
					"customer_price"=>2000,
					"customer_price_ex_tax"=>1666,
					"vehicle"=>"small_van",
					"pickup_start"=>"2014-10-01T00:45+01:00",
					"pickup_finish"=>"2014-10-01T03:00+01:00",
					"delivery_start"=>"2014-10-01T03:00+01:00",
					"delivery_finish"=>"2014-10-01T04:00+01:00",
					"valid_until"=>"2014-10-01T00:45+01:00",
					"delivery_promise"=>985,
					"delivery_promise_text"=>"delivery from 03:00 to 04:00 tomorrow for £20.00"
				}
			}
		}
	}

	let(:booking) {
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
						"postcode" =>        "N1 5SU"
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
						"postcode" =>        "E10 6LL"
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

	}

	before do
		stub_request(:post, "#{request_url}/quote_collections").with(:body => body.to_json, :headers => {'Authorization'=>'Bearer bZxImVvZImWgvkwHiAT4HQuOLwikANCtuRXeD4gIjwLixIfRJHoiFB0p3K6ZXy9oSo8ktkstdnK_W9TqXUcwCQ' }).to_return(:status => 200, :body => body_collection.to_json)
		stub_request(:post, "#{request_url}/bookings").with(:body => booking.to_json, :headers => {'Authorization'=>'Bearer bZxImVvZImWgvkwHiAT4HQuOLwikANCtuRXeD4gIjwLixIfRJHoiFB0p3K6ZXy9oSo8ktkstdnK_W9TqXUcwCQ' }).to_return(:status => 200, :body => {})
		visit '/quote'
		fill_in 'pickup_location', :with => 'N1 5SU'
		fill_in 'delivery_location', :with => 'E10 6LL'
		click_button 'Get quote'
	end

	it 'can get a quote for a job' do
		within('.prompt') do
			expect(page).to have_content 'You can order your sack of squirrels for delivery from 03:00 to 04:00 tomorrow for £20.00 !'
		end
	end

	it 'can book a job' do
		click_button 'Place Order'
		expect(page).to have_content 'Great success! The squirrels are on their way now!'
	end

	xit 'raises error when job couldn\'t be booked' do
		click_button 'Place Order'
		expect{page}.to raise_error
	end
end
