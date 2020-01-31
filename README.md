# Node Ts Lerna Starter

This starter contains what you need to start developing `nodejs` using `typescript`.
A personal perference I have is to use `lerna` for seperating to modules,
Even for smaller projects.

# Getting started

```bash
git clone git@github.com:gioragutt/node-ts-lerna-starter.git <project name>
cd <project name>
npm i
./create-package.sh main
```

# create-package.sh

This scripts handles the boilerplate of creating a new package.

The syntax is:

```bash
./create-package.sh [@my-scope/]package-name
```

This will create the following package:

```
packages/package-name
├── README.md
├── __tests__
│   └── package-name.test.js
├── lib
├── nodemon.json
├── package.json
├── src
│   ├── debug.ts
│   └── index.ts
└── tsconfig.json
```

# What each generated package has

## npm scripts

- `tsc`: required to run the build
- `build`: build the project and output to the `lib` directory
- `start`: run the module
- `start:watch`: runs the module in watch mode, using `nodemon`

## files

- `src/debug.ts` - exposes a root logger, using the `debug` library
- `src/index.ts` - the main of the module. contains `hello world` code using a `debug` logger.
