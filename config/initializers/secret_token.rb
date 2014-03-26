# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
LighthouseDb::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'a5812a12a4a608f0611b63e95fcf310916748094bdc845f283fe13f902648ba037fd9c29fb9f219d090eaa6f1fc563e801076d2604acc8efdb339a493da2c294'
