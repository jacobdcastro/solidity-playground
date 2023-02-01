const { ethers } = require('hardhat');
const CRYPTODEVS_NFT_CONTRACT_ADDRESS = process.env.NFT_CONTRACT_ADDRESS;

// Fake Marketplace Goerli Address: 0x76d09c8ED826B2b92D44D43810242DB202bb86dc
// CryptoDevsDAO Goerli Address: 0x25DB88A619BE1028Bb6e10D7343302C3238e3381

async function main() {
  // Deploy the FakeNFTMarketplace contract first
  const FakeNFTMarketplace = await ethers.getContractFactory(
    'FakeNFTMarketplace'
  );
  const fakeNftMarketplace = await FakeNFTMarketplace.deploy();
  await fakeNftMarketplace.deployed();

  console.log('FakeNFTMarketplace deployed to: ', fakeNftMarketplace.address);

  // Now deploy the CryptoDevsDAO contract
  const CryptoDevsDAO = await ethers.getContractFactory('CryptoDevsDAO');
  const cryptoDevsDAO = await CryptoDevsDAO.deploy(
    fakeNftMarketplace.address,
    CRYPTODEVS_NFT_CONTRACT_ADDRESS,
    {
      // This assumes your account has at least 1 ETH in it's account
      // Change this value as you want
      value: ethers.utils.parseEther('.05'),
    }
  );
  await cryptoDevsDAO.deployed();

  console.log('CryptoDevsDAO deployed to: ', cryptoDevsDAO.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
