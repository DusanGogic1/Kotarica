module.exports = {
  networks: {
    development: {
      host: "147.91.204.116",
      port: 11151,
      network_id: "*", // Match any network id
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
