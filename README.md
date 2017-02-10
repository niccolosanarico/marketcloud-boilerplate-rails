# Marketcloud Rails Boilerplate

This is a Rails-based boilerplate for a [Marketcloud](http://www.marketcloud.it)-powered e-commerce site. This boilerplate is built on top of Rails 5, bootstrap 3.4 and supports out of the box Braintree/Paypal payments (sorry, no Stripe yet), [segment.com](http://segment.com) analytics, [sendgrid](https://www.sendgrid.com) for emails and [Redis](https://www.redis.io) for basic caching of API calls to Marketcloud.

## Installation

The boilerplate is ready for deployment on Heroku. You just need an Heroku account and (quite unsurprisingly) a Marketcloud account
with a store ready ([start from here](https://www.marketcloud.it/account/signup)).

Just clone the repository and *git push* to heroku. See below to setup relevant environment variables to make it work.

## Environment variables

Setup the following environment variables to have a fully functional ecommerce:

- *marketcloud_private_key* = the private key of the Marketcloud store (MANDATORY)
- *marketcloud_public_key* = the public key of the Marketcloud store (MANDATORY)
- *REDIS_URL* = the url to a Redis instance (note: there is a free Redis tier on Heroku, and it automatically will setup this variable for you)
- *segment_key* = the API key to a segment.com account
- *SENDGRID_USERNAME* = username to a sendgrid account
- *SENDGRID_PASSWORD* = password to a sendgrid account

## Emails

The boilerplate includes basic email templates for the following events:

- User signup
- Password reset
- Order confirmation

## TODO & ISSUES

This boilerplate is still a WIP, and you may find issues here and there. Some known issues are:

- The store expects physical products, thus there is a manadatory shipping step in the checkout process. Remove it in case you want to sell digital items
- The address form treats "customer name" as a company name (yes, it has been set it up for a B2B store)


## Testing

Alas, test coverage is currently quite low.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/niccolosanarico/marketcloud-boilerplate-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
