require 'spec_helper'

describe "Mobivity Redemption Auth Spec" do 
  it "should return error if user does not exist" do
    client = Client.new("xy-4742", "xySD4742")
    res = client.get_user_with_rewards("%2B1-858-555-1212")
    expect(res["error"]["error_user_msg"]).to include("Authentication failure for username")
  end

  it "should return error if username and password does not match" do
    client = Client.new("xy4742", "xyzSD4742")
    res = client.get_user_with_rewards("%2B1-858-555-1212")
    expect(res["error"]["error_user_msg"]).to include("Authentication failure for username")
  end
end
 
describe 'Mobivity Redemption API Spec' do
  before do
    @client = Client.new("xy4742", "xySD4742")
    @user = @client.create_user("+1-858-531-0142", "male", "1990-08-25", "dotcom900825@gmail.com")

  end

  it 'can retrieve existing user by cellphone' do
    res = @client.get_user_with_rewards("%2B1-858-555-1212")
    expect(res["phone"]).to eq("+1-858-555-1212")
  end

  it 'can retrieve existing user by user id' do
    res = @client.get_user_with_rewards("5159696684023808")
    expect(res["phone"]).to eq("+1-858-555-1212")
  end

  it "can't retrieve a user by phone number that does not follow E.164 format" do
    res = @client.get_user_with_rewards("858-531-0142")
    expect(res["error"]["error_user_msg"]).to include("nvalid literal for long()")
  end

  it "can create a user by a set of attributes" do
    res = @client.create_user("+1-859-531-0142", "male", "1991-08-25", "abc@gmail.com")
    expect(res["phone"]).to eq("+1-859-531-0142")
    expect(res["birthday"]).to eq("1991-08-25")
    expect(res["gender"]).to eq("male")
    expect(res["email"]).to eq("abc@gmail.com")
  end

  it "can credit user account after a transaction completes and see the balance change" do
    res = @client.get_user_with_rewards("%2B1-858-531-0142")
    current_bal = res["balance"]

    res = @client.credit_user("%2B1-858-531-0142", 5.00)
    expect(res["success"]).to eq(true)
    res = @client.get_user_with_rewards("%2B1-858-531-0142")
    expect(res["balance"]).to eq(current_bal+1)
  end

  it "can redeem the rewards if the user has any" do 
    res = @client.get_user_with_rewards("%2B1-858-555-1212")
    expect(res["rewards"].size).to be > 0
    reward_count = res["rewards"].size

    reward_link = res["rewards"].last["redemption_link"]
    res = @client.reward_redemption(reward_link)
    expect(res["success"]).to eq(true)

    res = @client.get_user_with_rewards("%2B1-858-555-1212")
    expect(res["rewards"].size).to eq(reward_count - 1)
  end

  it "can't allow user redeem the same rewards for twice" do
    res = @client.get_user_with_rewards("%2B1-858-555-1212")
    reward_link = res["rewards"].last["redemption_link"]
    res = @client.reward_redemption(reward_link)
    expect(res["success"]).to eq(true)

    res = @client.reward_redemption(reward_link)
    expect(res["error"]["error_user_msg"]).to eq("offer already redeemed")

  end


end