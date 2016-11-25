# SIX

A gem that allows to interact with SIX Financial Information API without testing your pain
tolerance.

## Installation

Add this line to your application's Gemfile:

    gem 'six', '~> 0.3.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install six

## Usage

Instantinate a client:
    
    client = SIX::Client.new(your_six_login, password)

Identify an instrument:
    
    listing_id = client.identify_instrument(isin_of_the_instrument)

Fetch prices:

    client.hiku_data(listing_id)

All available prices for the past year:

    client.hiku_data(listing_id, date_from: 1.year.ago, price_quote_selection:
    Price::AVAILABLE)

## Contributing

1. Fork it ( https://github.com/Fundbase/six/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
