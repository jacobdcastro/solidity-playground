import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import dotenv from 'dotenv';
dotenv.config({ path: __dirname + '/.env' });

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || '';
const DEV_PRIVATE_KEY = process.env.DEV_PRIVATE_KEY || '';

const config: HardhatUserConfig = {
  solidity: '0.8.17',
  networks: {
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [DEV_PRIVATE_KEY],
    },
  },
};

export default config;
