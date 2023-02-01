require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config({ path: '.env' });

const ALCHEMY_RPC_URL = process.env.ALCHEMY_RPC_URL;

const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY;

module.exports = {
  solidity: '0.8.9',
  networks: {
    goerli: {
      url: ALCHEMY_RPC_URL,
      accounts: [WALLET_PRIVATE_KEY],
    },
  },
};
