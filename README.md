#Installation

bundle install

#Run the test

rake spec

#Tools used

For this Mobivity API project, I used **Ruby** and **RSpec framework** to test the given API spec. To issue HTTP request, I adopted the **rest-client** gem which is a popular simple HTTP and REST client for Ruby.

#Approach used
To test the spec of the API, I implemented a simple Mobivity API client under lib folder, which is a simple wrapper around the Mobivity API. It can issue the API call with different parameters and return the results in json format. After that, I start working on the RSpec code, following the instructions provided and API spec, I have managed to come up with the testing code for all of the required API call included in the project description.

#API limitation
* How would the initial rewards get populated for a given user account, there is no API that can enable end users to do that. When we creating the user, we should be able to pass the corresponding merchant info alongside, and on the server side we can set some default rewards for such customers, so when the creation is complete, the user would automatically have the rewards under a specific merchant.

* The API spec said, when we create a new user or query a user that does not exist through cell phone number, the end user should be able to receive a text message containing a link for user to input their personal info, however, I did not receive such message. It can be easily implemented using 3rd party service such as Twilio.


* The get redemption API won't return the reward value, it only returns success status which is in consistant with the Retrieving rewards for user user story





#Bugs found
* One bug I have noticed is that when I try to create a user through the given portal: http://mobivityloyaltyapi.appspot.com/web/index.html, you can succefully create a user with "-" in the username, but when you start using this credential for the authentication, the server-side will igonore the string after the dash and give user not found exception. So there is some inconsistance in the system.

* Another issue I found is that on the API server-side, there is no validation check on the email, phone number format, gender and birthday attributes. So we can POST arbitray data to the server side and it will still get processed.

* The reward restoration API seems doesn't work for me, I have tried issuing PUT request but I saw **HTTPMethodNotAllowed** error shows up

* When adding credit to the user, the balance attribute for the user is not reflecting the credit value. For example, I can credit the user +1-858-555-1212 a $4.00 purchase, but the user's balance would only show a incremention of 1.

