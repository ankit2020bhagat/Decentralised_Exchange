import { Contract, ethers, Signer } from "ethers";
import {
    EXCHANGE_CONTRACT_ABI,
    EXCHANGE_CONTRACT_ADDRESS,
    TOKEN_CONTRACT_ABI,
    TOKEN_CONTRACT_ADDRESS,
} from "../constants/index.js";


export const Addliquidity = async(signer,amount,ethAmount) => {
    try{
       const Token_Contract = new ethers.Contract(TOKEN_CONTRACT_ADDRESS,TOKEN_CONTRACT_ABI,Signer);
       const txn_approve = await Token_Contract.approve(EXCHANGE_CONTRACT_ADDRESS,amount.toString());
       await txn_approve.wait();
    }catch(e){
        console.log(e)
    }

    try{
    const Exchange_Contract = new ethers.Contract(EXCHANGE_CONTRACT_ADDRESS,EXCHANGE_CONTRACT_ABI,signer);
    const txn_addliquidity = await Exchange_Contract.addLiquidity(amount,{value:ethers.utils.parseEther(ethAmount)})
    await txn_addliquidity.wait();
    }catch(e){
        console.log(e);
    }

} 