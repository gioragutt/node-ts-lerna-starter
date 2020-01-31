set -e

main() {
  if [ ! $1 ]; then
    echo "Usage: $0 <package name> [...more lerna create args]"
    exit 1
  fi

  local NAME=$(echo $1 | cut -d/ -f2)

  lerna create $@

  cd packages/$NAME
  
  add_npm_scripts $NAME
  add_tsconfig $NAME
  add_index $NAME
  add_logger $NAME
}

add_npm_scripts() {
  local NAME=$1

  npm i -D rimraf nodemon
  update_package_json '.scripts.tsc |= "tsc"'
  update_package_json '.scripts.build |= "rimraf ./lib && tsc"'
  update_package_json ".scripts.start |= \"npm run build && DEBUG=$NAME:* node .\""
  add_nodemon

  echo "Added npm scripts to $NAME package.json"
}

add_nodemon() {
    cat > ./nodemon.json <<EOF
{
  "watch": [
    "src"
  ],
  "ext": ".ts,.js",
  "ignore": [],
  "exec": "npm start"
}
EOF
  update_package_json '.scripts["start:watch"] |= "nodemon"'
}

add_tsconfig() {
  local NAME=$1
  cat > ./tsconfig.json <<EOF
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./lib"
  },
  "include": [
    "./src"
  ]
}
EOF
  echo "Added tsconfig.json to $NAME"
}

add_index() {
  local NAME=$1
  mkdir src
  
  cat > src/index.ts <<EOF
import { rootLogger } from './debug';

const debug = rootLogger.extend('main')

async function main() {
  debug('Hello World!')
}

main().catch(console.error);
EOF

  rm lib/$NAME.js
  update_package_json '.main |= "lib/index.js"'
  update_package_json '.typings |= "lib/index.d.ts"'
  echo "Added src/index.ts to $NAME"
}

add_logger() {
  local NAME=$1
  cat > src/debug.ts <<EOF
import debug from 'debug';

export const rootLogger = debug('${NAME}')
EOF
  echo "Added debug.ts to $NAME"
}

update_package_json() {
  local JQ_COMMAND=$1

  local OUTPUT=$(mktemp)
  local PACKAGE_JSON=./package.json
  jq -r "$JQ_COMMAND"  $PACKAGE_JSON > $OUTPUT
  mv $OUTPUT $PACKAGE_JSON
}

main $@