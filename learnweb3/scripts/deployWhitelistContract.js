const { ethers } = require('hardhat');

// Whitelist.sol Goerli Address: 0x3A10283f7e4B559D579B7427B124AcE8EC65bb60

async function main() {
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so whitelistContract here is a factory for instances of our Whitelist contract.
  */
  const whitelistContract = await ethers.getContractFactory('Whitelist');

  const deployedWhitelistContract = await whitelistContract.deploy(10);

  await deployedWhitelistContract.deployed();

  console.log('Whitelist Contract Address:', deployedWhitelistContract.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
