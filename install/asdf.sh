# Run this scripts to install your favor toolchain

# Nodejs
asdf plugin-add nodejs
  asdf install nodejs 10.15.0
  asdf global nodejs 10.15.0
# Rust
asdf plugin-add rust 
  asdf install rust nightly
  asdf global rust nightly
# Elixir
asdf plugin-add elixir
  asdf install elixir 1.9.0-otp-22
  asdf global elixir 1.9.0-otp-22
# Erlang
# Without Erlang, Elixir code has no virtual machine to run on
# so we need to install Erlang as well.
asdf plugin-add erlang
  asdf install erlang 22.0.7
  asdf global erlang 22.0.7
