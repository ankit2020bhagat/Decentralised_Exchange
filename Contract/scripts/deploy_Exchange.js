const { verify } = require("../utils/verify");
const hre = require("hardhat");

async function main() {
  const exchangeConrtract = await hre.ethers.getContractFactory("Exchange");
  const deployeContract = await exchangeConrtract.deploy(
    "0x77C489dAE9C6E412f442D0542A29b7506D9d2C82"
  );
  await deployeContract.deployed();
  console.log("Contract Address:", deployeContract.address);
  await deployeContract.deployTransaction.wait(5);
  await verify(deployeContract.address, [
    "0x77C489dAE9C6E412f442D0542A29b7506D9d2C82",
  ]);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
