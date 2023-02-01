const { ethers } = require('hardhat');
require('dotenv').config({ path: '.env' });

// Exchange Goerli address: 0x626B740447f59D6c38ac163C7972C917757c0D06

const cryptoDevTokenAddress = '0x6CF9FC8589B1Fb61f39d57775E4Cf040DA8853e4';

async function main() {
  const exchangeContract = await ethers.getContractFactory('Exchange');

  // here we deploy the contract
  const deployedExchangeContract = await exchangeContract.deploy(
    cryptoDevTokenAddress
  );
  await deployedExchangeContract.deployed();

  // print the address of the deployed contract
  console.log('Exchange Contract Address:', deployedExchangeContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
