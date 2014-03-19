# Nvlope

Ruby wrapper for the nvlope.com API

## Installation

Add this line to your application's Gemfile:

    gem 'nvlope'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nvlope

## Usage

```ruby

evlope = Evlope.new(
  username:      'INTENTIONALLY LEFT BLANK',
  password:      'INTENTIONALLY LEFT BLANK',
  client_id:     'INTENTIONALLY LEFT BLANK',
  client_secret: 'INTENTIONALLY LEFT BLANK',
)

evlope.get_access_token
evlope.revoke_access_token
evlope.get_session
evlope.mail.send

evlope.messages.query
evlope.messages.bulk_get
evlope.messages.delete
evlope.messages.unread
evlope.messages.update_labels
evlope.messages.get_labels

evlope.notification.receive

evlope.files.upload
evlope.files.query
evlope.files.delete
evlope.files.set_expiration
evlope.files.get_public_link
evlope.files.get_private_link

evlope.account.profile
evlope.account.quota
evlope.account.mailboxes
evlope.account.domains

evlope.contacts.create
evlope.contacts.update
evlope.contacts.list
evlope.contacts.delete

```

## Documentation

http://developer.nvlope.com/

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nvlope/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
