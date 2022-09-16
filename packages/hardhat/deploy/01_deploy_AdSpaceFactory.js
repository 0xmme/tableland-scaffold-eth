/* eslint-disable no-unused-vars */
// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

// const OP_GOE_TABLELANDCONTRACT = "0xc72e8a7be04f2469f8c2db3f1bdf69a7d516abba";
const GOE_TABLELANDCONTRACT = "0xDA8EA22d092307874f30A1F277D1388dca0BA97a";

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  console.log(chainId);

  // localhost?
  // const TablelandTables = await ethers.getContract("TablelandTables", deployer);
  // const localTablelandTablesAddress = TablelandTables.address;

  // await deploy("AdSpaceFactory", {
  //  // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  //  from: deployer,
  //  args: [localTablelandTablesAddress],
  //  log: true,
  //  waitConfirmations: 5,
  // });
  // Optimism Goerli?
  // await deploy("AdSpaceFactory", {
  //  // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  //  from: deployer,
  //  args: [OP_GOE_TABLELANDCONTRACT],
  //  log: true,
  //  waitConfirmations: 5,
  // });

  // Goerli?
  await deploy("AdSpaceFactory", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    args: [GOE_TABLELANDCONTRACT],
    log: true,
    waitConfirmations: 5,
  });

  // verifiying on goerli
  const AdSpaceFactory = await ethers.getContract("AdSpaceFactory", deployer);
  try {
    await run("verify:verify", {
      address: AdSpaceFactory.address,
      contract: "contracts/AdSpaceFactory.sol:AdSpaceFactory",
      constructorArguments: [GOE_TABLELANDCONTRACT],
    });
  } catch (error) {
    console.error(error);
  }
};

module.exports.tags = ["AdSpaceFactory", "all"];
