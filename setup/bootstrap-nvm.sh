#!/bin/bash

THIS_DIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

NVM_VER="0.40.1"
NVM_INST_FILE="nvm-${NVM_VER}-install.sh"

if [ ! -e "inst/${NVM_INST_FILE}" ]
then
    mkdir -p inst
    wget -O "inst/${NVM_INST_FILE}" "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VER}/install.sh"
fi

MY_ENV_FILE="my-env.sh"
if [ ! -e "${MY_ENV_FILE}" ]
then
    cat > "${MY_ENV_FILE}" <<EOF
#!/bin/bash
THIS_DIR=\$(dirname \$(realpath "\${BASH_SOURCE[0]}"))

# <NVM-RELATED>
export XDG_CONFIG_HOME="\${THIS_DIR}"

export NVM_DIR="\${THIS_DIR}/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && source "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && source "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [ -e '.nvmrc' ] && [[ \$(type -t nvm) == "function" ]]; then
    nvm use
else
    if [ -e "\${THIS_DIR}/.nvm/versions/node" ]; then
        # Note: nvm use will re-set up these env vars
        _NVM_DIR=\$(ls -trd "\${THIS_DIR}/.nvm/versions/node"/v?.*.* | sort | tail -n 1)
        export NVM_INC="\${_NVM_DIR}/include/node"
        export NVM_BIN="\${_NVM_DIR}/bin"
    fi
fi
# </NVM-RELATED>

PATH="\${THIS_DIR}/node_modules/.bin:\${PATH}"  # for npm-installed tools

EOF
    chmod +x "${MY_ENV_FILE}"
fi

mkdir -p .nvm

# Need some vars set for installing NVM here
source my-env.sh

# Install NVM
bash "inst/${NVM_INST_FILE}"

# Now this will load nvm into our environment
source my-env.sh

# Emit some helpful text..
cat <<EOF
Some suggestions for next steps:

source ./my-env.sh
nvm install lts/fermium
[ -e ".nvmrc" ] || echo "lts/fermium" > .nvmrc
nvm use

# Maybe?
npm init -y
npm install -D typescript
npm install -D yarn

# Maybe?
npx create-react-app myapp --template typescript

# Maybe?
npm init vite cool-app

EOF
