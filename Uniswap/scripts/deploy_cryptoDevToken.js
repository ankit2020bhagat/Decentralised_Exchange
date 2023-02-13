const { verifyMessage } = require("ethers/lib/utils");
const { run } = require("hardhat");
const  hre = require("hardhat")

async function main(){
    const cryptoDev_Factory = await hre.ethers.getContractFactory("CryptoDevToken");
    const deploy_cryptoDevToken = await cryptoDev_Factory.deploy();
    await deploy_cryptoDevToken.deployed();
    console.log("Contract deployed to ",deploy_cryptoDevToken.address);
    await deploy_cryptoDevToken.deployTransaction.wait(5);
    await verify(deploy_cryptoDevToken.address,[]);
}

const verify = async(contractAddress,args) =>{
   console.log("Verifying Contract.....");
   try{
    await run("verify:verify",{
        address: contractAddress,
        constructorArguments: args,
    })
   }catch(e){
    if(e.message.toLowerCase().includes('already verified'))
    console.log("Already verified");
    else{
        console.log(e);
    }
   }
}

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error){
        console.log(error)
        process.exit(1);
    }
}
runMain();
