import { Contract, ethers } from "ethers";
import {
    EXCHANGE_CONTRACT_ABI,
    EXCHANGE_CONTRACT_ADDRESS,
    TOKEN_CONTRACT_ABI,
    TOKEN_CONTRACT_ADDRESS,
} from "../constants/index.js";


export const getEtherBalance = async (provider, address, contract = false) => {
    console.log("Exchange abi", EXCHANGE_CONTRACT_ABI);
    try {
        if (contract) {
            const balance = await provider.getBalance(EXCHANGE_CONTRACT_ADDRESS);
            console.log("Contract Balance", balance.toString());
            return balance;
        } else {
            const balance = await provider.getBalance(address);
            console.log("User balance", balance);
            return balance;
        }
    } catch (error) {
        console.log(error);
        return 0;
    }


}

export const getCDTokenBalance = async (provider, address) => {

    try {
        const tokenContract =  new ethers.Contract(TOKEN_CONTRACT_ADDRESS, TOKEN_CONTRACT_ABI, provider);
        const tokenBalance = await tokenContract.balanceOf(address);
        console.log("token balance", tokenBalance);
        return tokenBalance;
    } catch (error) {
        console.log(error);
        return 0;
    }
}

export const getLPTokenBalance = async (provider, address) => {
    try {
        const Exchange_Contract = new ethers.Contract(EXCHANGE_CONTRACT_ADDRESS, EXCHANGE_CONTRACT_ABI, provider);
        const balance = await Exchange_Contract.balanceOf(address);
        return balance;
        console.log(`LP token balance in ${address} ${balance}`);
    } catch (e) {
        console.log(e);
        return 0;
    }
}

export const getReserveOfCDToken = async (provider) => {
    try{
    const Exchange_Contract = new ethers.Contract(EXCHANGE_CONTRACT_ADDRESS, EXCHANGE_CONTRACT_ABI, provider);
    const balance = await Exchange_Contract.getReserve();
    console.log(`Reserve of CD token  ${balance}`)
    return balance;
    }catch(e){
        console.log(e);
        return balance;
    }
}




const runMain = async () => {
    try {
        await getEtherBalance();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

//runMain();