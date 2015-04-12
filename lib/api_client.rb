require 'rest_client'
require "json"

class Client
  
  
  def initialize(username, password)
    @username = username
    @password = password    
    @prefix = "https://#{@username}:#{@password}@mobivityloyaltyapi.appspot.com"
  end

  def get_user_with_rewards(id)
    res = RestClient.get "#{@prefix}/users/#{id}"
    JSON.parse(res)
  end

  def create_user(phone_num, gender=nil, birthday=nil, email=nil)
    res = RestClient.post("#{@prefix}/users", {
      :phone=>phone_num,
      :gender=>gender,
      :birthday=>birthday,
      :email=>email
      }.to_json
    )
    JSON.parse(res)
  end

  def credit_user(id, value)
    res = RestClient.post "#{@prefix}/users/#{id}/credit", {:posttype=>"yogurtini-rpower", :datetime=>Time.now, :value=>value, :receipt=>receipt}
    JSON.parse(res)
  end

  def reward_redemption(link)
    res = RestClient::Request.new(:method=>:get, :url=>link, :user=>@username, :password=>@password, :headers=>{:accept=>:json, :content_type=>:json}).execute
    JSON.parse(res)
  end

  def reward_restoration(link)
    res = RestClient::Request.new(:method=>:post, :url=>link, :user=>@username, :password=>@password, :headers=>{:accept=>:json, :content_type=>:json}).execute
    JSON.parse(res)
  end

  def receipt
    str = "
^[@^[!^@             ^[! Yogurtini
^[!^@           2510 W Happy Valley Rd
                 Suite #1251
              Phoenix, AZ 85085
                623-580-1200

  Cntr ^[!0143^[!^@    07/22/14-A ^[!  2:21pm
^[!^@  Guests ^[! 1^[!^@ Cashier 1      Table (STANDEE)

              Reward 818...3266
          You now have 21.08 points
           including this purchase
             (previously 16.67)
  ----------------------------------------
  1..1 Cup
     Small (16oz)                     4.41
     10.5oz @ $0.42/oz
                                   -------
                     Items            4.41
                       Tax             .37
                ^[! TOTAL^[!^@        ^[!04.78
^[!^@
                  ^[! Cash^[!^@        ^[! 5.00
^[!^@  ^[! (Change due)^[!^@          ^[! .22
^[!^@       Check 143 PAID 2:21pm CASH1#1-A

  818-321-3266 M           Yogurtini Loyal
  Prch       4.41      441              OK

             Like us on Facebook
             for special offers.
   www.facebook.com/yogurtininorterrashops
"
  return str
  end
end

