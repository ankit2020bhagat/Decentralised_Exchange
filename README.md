Decentralized Exchange (DEX) Contract
Introduction
This repository contains a Solidity smart contract implementing a decentralized exchange (DEX) known as the "Exchange" contract. This DEX contract allows users to add liquidity, perform token swaps, and manage ERC20 tokens and Ether (ETH).
Contract Overview
The "Exchange" contract is a Solidity smart contract that facilitates decentralized token swaps and liquidity provision. It is built on the Ethereum blockchain and utilizes the OpenZeppelin library for ERC20 token functionality and reentrancy protection.
Features
Liquidity Provision: Users can add liquidity by providing both CryptoDev tokens and ETH to the contract, receiving LP tokens in return.
Token Swaps: Users can swap Ether (ETH) for CryptoDev tokens or vice versa, using the built-in swap functions.
Liquidity Removal: Users can remove liquidity by burning LP tokens, receiving back CryptoDev tokens and ETH.
Reserve Management: The contract provides functions to retrieve the current reserves of CryptoDev tokens and ETH.
Getting Started
Prerequisites
Ethereum development environment (such as Truffle)
OpenZeppelin library
Installation
Clone this repository: git clone https://github.com/ankit2020bhagat/Decentralised_Exchange.git
Install dependencies: npm install
Configure the development environment as needed.
Usage
Deploy the "Exchange" contract to the Ethereum blockchain.
Interact with the contract using Ethereum wallets or through smart contract interactions.
Refer to the contract functions and events for detailed usage information.
Contract Details
Constructor
The contract constructor initializes the "Exchange" contract, requiring the address of the CryptoDev ERC20 token to be used in the exchange.

Functions
addLiquidity(uint tokenAmount) external payable: Add liquidity by providing CryptoDev tokens and ETH. Returns the amount of LP tokens minted.
removeLiquidity(uint LPtokenamount) external: Remove liquidity by burning LP tokens, receiving back CryptoDev tokens and ETH.
swapEthToToken(uint \_minToken) external payable: Swap ETH to CryptoDev tokens based on the provided ETH amount.
swapTokenToETH(uint \_tokenSold, uint \_mintETH) public: Swap CryptoDev tokens to ETH based on the provided token amount.
Events
AddLiquidity(address indexed from, address indexed tokenAddress, uint indexed tokenAmount, uint ETHAmount, uint liquidity): Emitted upon liquidity addition.
RemoveLiquidity(address indexed from, uint indexed LpTokenAmount, uint indexed ETHAmount, uint tokenAmount): Emitted upon liquidity removal.
SwapETHToToken(address indexed from, uint indexed ETHamount, uint indexed tokenAmount): Emitted upon ETH to token swap.
SwapTokenToETH(address indexed from, uint indexed tokenAmount, uint indexed ETHAmount): Emitted upon token to ETH swap.
License
This project is licensed under the MIT License. See the LICENSE file for details.
