#!/bin/bash

# Simple helper script for Coolify deployment

# Create a simple .env file
echo "# Simple Rust Server Configuration" > .env
echo "SERVER_NAME=Rust Server" >> .env
echo "RCON_PASSWORD=password" >> .env

echo "Created simple .env file for Coolify"
echo "You can now deploy through Coolify" 