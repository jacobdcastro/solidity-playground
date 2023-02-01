const { ethers } = require('hardhat');
require('dotenv').config({ path: '.env' });

// CryptoDevs.sol Goerli Address: 0xB9DF6789589D5D38d6129c08BD3A8F1fbd0546Bb

const WHITELIST_CONTRACT_ADDRESS = process.env.WHITELIST_CONTRACT_ADDRESS;
const METADATA_URL = process.env.METADATA_URL;

async function main() {
  // Address of the whitelist contract that you deployed in the previous module
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  // URL from where we can extract the metadata for a Crypto Dev NFT
  const metadataURL = METADATA_URL;
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so cryptoDevsContract here is a factory for instances of our CryptoDevs contract.
  */
  const cryptoDevsContract = await ethers.getContractFactory('CryptoDevs');

  // deploy the contract
  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    metadataURL,
    whitelistContract
  );

  // print the address of the deployed contract
  console.log(
    'Crypto Devs Contract Address:',
    deployedCryptoDevsContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
