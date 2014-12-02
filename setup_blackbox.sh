#!/bin/bash

# Manuel Tiago Pereira (mt.pereira@gmail.com)
#
# Installs blackbox (https://github.com/StackExchange/blackbox), creates a
# dedicated GPG key for it and adds it to a specified repository.
#
# Typical usage: ./setup_blackbox.sh EMAIL PASSWORD REPOSITORY
# Example: ./setup_blackbox.sh "mail@domain.tld" "password-for-new-key" "git@github.com:user/my_safe_repo.git"

set -eu

gpg_create() {
  local email="${1}"
  local password="${2}"
  local comment="${3}"
  local config=$(mktemp -t gpg-XXXXX)

  echo "Creating GPG key..."
  cat > ${config} <<EOF
    %echo Generating a basic OpenPGP key
    Key-Type: DSA
    Key-Length: 1024
    Subkey-Type: ELG-E
    Subkey-Length: 1024
    Name-Real: $(finger $(whoami) | egrep -o -w 'Name: .+' | sed -e 's/^Name: //')
    Name-Comment: ${comment}
    Name-Email: ${email}
    Expire-Date: 0
    Passphrase: ${password}
    %commit
EOF

  gpg --batch --gen-key ${config}
  rm ${config}
}

blackbox_install() {
  local tmpdir=$(mktemp -d -t blackbox-XXXXX)

  echo "Installing blackbox..."
  git clone https://github.com/StackExchange/blackbox ${tmpdir}
  sudo cp ${tmpdir}/bin/*.sh ${tmpdir}/bin/blackbox_* /usr/local/bin/
  rm -rf ${tmpdir}
}

blackbox_add() {
  local email="${1}"
  local repository="${2}"
  local tmpdir=$(mktemp -d -t vault-XXXXX)

  echo "Adding GPG key to blackbox..."
  git clone "${repository}" ${tmpdir}
  cd ${tmpdir}
  git checkout -b "${email}"
  blackbox_addadmin ${email}
  git commit -m "NEW ADMIN: ${email}' keyrings/live/pubring.gpg keyrings/live/trustdb.gpg keyrings/live/blackbox-admins.txt"
  git push origin "${email}"
  rm -rf ${tmpdir}
}

main() {
  local email="${1}"
  local password="${2}"
  local repository="${3}"
  local comment="Generated on $(hostname) by $(whoami) for blackbox."

  gpg_create ${email} "${password}" "${comment}"
  blackbox_install
  blackbox_add ${email} "${repository}"
}

main "$@"

