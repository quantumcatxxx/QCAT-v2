require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.28",
  networks: {
    qan: {
      url: `https://rpc-testnet-dev.qanplatform.com`,

      accounts: [
        "YOUR_PRIVATE_KEY_HERE",
      ],
    },
  },
};
