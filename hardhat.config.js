require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.6.12",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/5e14b8949f6b473f9cfc5adc98f1704f`,

      accounts: [
        "0xf7b4bc954f77ea129f4be607d12440eef972646425a8f440590d30234b3bec4c",
      ],
    },
  },
};
