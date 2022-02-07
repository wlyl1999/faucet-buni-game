require("dotenv").config();

import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-web3";
import "@nomiclabs/hardhat-etherscan";
import "@openzeppelin/hardhat-upgrades";
import 'hardhat-contract-sizer';

import { task } from "hardhat/config";
import { ethers } from "hardhat";

const privateKey = "0x" + process.env.PRIVATE_KEY;
const etherscan = process.env.ETHERSCAN;
const bscscan = process.env.BSCSCAN;



// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
// task("accounts", "Prints the list of accounts", async () => {
//   const accounts = await ethers.getSigners();

//   for (const account of accounts) {
//     console.log(await account.getAddress());
//   }
// });

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  //defaultNetwork: "localhost",
  networks: {
    local: {
      url: "http://localhost:8545",
    },
    kovan: {
      url: "https://kovan.infura.io/v3/9240293239dc4327b275d4f66b6d8008",
      accounts: [privateKey],
    },
     bsc: {
       url: "https://bsc-dataseed.binance.org/",
       accounts: [privateKey],
     },
  },
  etherscan: {
    apiKey: etherscan,
    bsc: bscscan,
  },
  solidity: {
    version: "0.6.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    tests: "./test",
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  mocha: {
    timeout: 100000,
  },
};
