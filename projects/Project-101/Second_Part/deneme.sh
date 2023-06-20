#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]; then
  echo "This script must be run with superuser privileges." >&2
  exit 1
fi

# Get the username (login).
read -p "Enter the username (login): " username

# Get the real name (contents for the description field).
read -p "Enter the real name: " realname

# Generate a random password.
password=$(openssl rand -base64 12)

# Create the account.
useradd -c "${realname}" -m "${username}"

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]; then
  echo "Failed to create the account." >&2
  exit 1
fi

# Set the password using chpasswd.
echo "${username}:${password}" | chpasswd

# Check to see if the chpasswd command succeeded.
if [[ "${?}" -ne 0 ]]; then
  echo "Failed to set the password." >&2
  exit 1
fi

# Force password change on first login.
passwd -e "${username}"

# Display the username, password, and the host where the user was created.
echo "Username: ${username}"
echo "Password: ${password}"
echo "Host: ${HOSTNAME}"
