# csgo-bot
an csgo discord bot that gets skin data and prices made using lua on luvit framework

# requirements

1. you need rust to build the threading library using cargo build --release

2. python 3 must be installed and then get the selenium library using pip install selenium or pip3 install selenium

3. you need chrome or firefox drivers because the project uses headless browser for additional functionalities for firefox get the geckodriver.

# how to run
download luvit from https://luvit.io/

and run this command in terminal in the current directory luvit index.lua

also get a public token from discord gateway for running this discord bot and make a config.txt file and put token like this Bot ${token}


# discord commands 
!commands shows all the available commands for the discord bot
!alias shows all the alias for !get command example - !get alias skin-name
!featured shows all the featured skins
!get gets the skin data - example !get deagle Conspiracy