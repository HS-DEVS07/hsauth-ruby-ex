# HS DEVS AUTH — Ruby Client SDK

Official Ruby library for HS DEVS AUTH.

## Usage

```ruby
require_relative 'lib/hsauth'

auth = HSAuth.new("AppName", "OwnerID", "Secret", "1.0")
if auth.license("YOUR_KEY")
  puts "Valid until #{auth.user_data['expiry']}"
end
```
