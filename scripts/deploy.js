const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  //   const HelloWorld = await ethers.getContractFactory("HelloWorld");
  //   const contract = await HelloWorld.deploy();

  //   console.log("Contract deployed at:", contract.address);

  //   const saySomething = await contract.speak();

  //   console.log("saySomething value:", saySomething);

  const BuyContract = await ethers.getContractFactory("TokenWithTaxAndStaking");
  const contract = await BuyContract.deploy();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
