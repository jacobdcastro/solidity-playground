import { ethers } from 'hardhat';

async function main() {
  // We get the contract to deploy
  const Factory = await ethers.getContractFactory('TelephoneHack');
  const factory = await Factory.deploy();

  await factory.deployed();

  console.log('Factory deployed to:', factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
