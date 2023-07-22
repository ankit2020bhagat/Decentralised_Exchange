// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Exchange
 * @dev A decentralized exchange (DEX) contract that allows users to add liquidity and perform token swaps.
 */
contract Exchange is ERC20, ReentrancyGuard {
    // Custom error messages
    error ZeroAddress();
    error InsufficientAmount();
    error MustBeGraterthanZero();
    error LessThanMinimiumTokenExpected();
    error LessThanMinimiumETHExpected();
    error TransferFailed();

    // Events
    event AddLiquidity(
        address indexed from,
        address indexed tokenAddress,
        uint indexed tokenAmount,
        uint ETHAmount,
        uint liquidity
    );

    event RemoveLiquidity(
        address indexed from,
        uint indexed LpTokenAmount,
        uint indexed ETHAmount,
        uint tokenAmount
    );

    event SwapETHToToken(
        address indexed from,
        uint indexed ETHamount,
        uint indexed tokenAmount
    );
    event SwaptokenToETH(
        address indexed from,
        uint indexed tokenAmount,
        uint indexed ETHAmount
    );

    address public cryptoDevTokenAddress;

    /**
     * @dev Constructor to initialize the exchange contract.
     * @param _cryptoDevToken The address of the ERC20 token to be used in the exchange.
     */
    constructor(address _cryptoDevToken) ERC20("CryptoDev Lp Token", "CDLT") {
        if (_cryptoDevToken == address(0)) {
            revert ZeroAddress();
        }
        cryptoDevTokenAddress = _cryptoDevToken;
    }

    /**
     * @dev Get the current reserve of the CryptoDev token in the exchange.
     * @return The reserve amount of the CryptoDev token.
     */
    function getReserve() public view returns (uint) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    /**
     * @dev Add liquidity to the exchange by providing both tokens and ETH.
     * @param tokenAmount The amount of CryptoDev tokens to be provided.
     * @return The amount of liquidity (Lp tokens) minted for the user.
     */
    function addLiquidity(
        uint tokenAmount
    ) external payable nonReentrant returns (uint) {
        uint liquidity;
        uint ethBalance = address(this).balance;
        uint cryptoDevReserve = getReserve();

        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        if (cryptoDevReserve == 0) {
            cryptoDevToken.transferFrom(msg.sender, address(this), tokenAmount);

            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else {
            uint ethReserve = address(this).balance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevReserve) /
                ethReserve;

            if (tokenAmount < cryptoDevTokenAmount) {
                revert InsufficientAmount();
            }
            cryptoDevToken.transferFrom(
                msg.sender,
                address(this),
                cryptoDevTokenAmount
            );
            liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);
        }

        emit AddLiquidity(
            msg.sender,
            cryptoDevTokenAddress,
            tokenAmount,
            msg.value,
            liquidity
        );
        return liquidity;
    }

    /**
     * @dev Remove liquidity from the exchange by burning LP tokens and receiving back ETH and CryptoDev tokens.
     * @param LPtokenamount The amount of LP tokens (liquidity) to remove.
     * @return The amount of ETH and CryptoDev tokens received by the user.
     */
    function removeLiquidity(
        uint LPtokenamount
    ) external nonReentrant returns (uint, uint) {
        if (LPtokenamount <= 0) {
            revert MustBeGraterthanZero();
        }
        uint ethReserve = address(this).balance;
        uint ethAmount = (LPtokenamount * ethReserve) / totalSupply();
        uint cryptoDevTokenAmount = (LPtokenamount * getReserve()) /
            totalSupply();
        _burn(msg.sender, LPtokenamount);

        (bool success, ) = msg.sender.call{value: ethAmount}("");
        if (!success) {
            revert TransferFailed();
        }
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
        emit RemoveLiquidity(
            msg.sender,
            LPtokenamount,
            ethAmount,
            cryptoDevTokenAmount
        );
        return (ethAmount, cryptoDevTokenAmount);
    }

    /**
     * @dev Calculate the amount of tokens to be received in a token swap.
     * @param inputAmount The amount of input tokens.
     * @param inputReserve The reserve of the input token.
     * @param outputReserve The reserve of the output token.
     * @return The amount of output tokens to be received.
     */
    function getAmountofToken(
        uint inputAmount,
        uint inputReserve,
        uint outputReserve
    ) public pure returns (uint) {
        if (inputAmount <= 0 && outputReserve <= 0) {
            revert MustBeGraterthanZero();
        }
        uint inputAmountwithFees = inputAmount * 99;
        uint numerator = inputAmountwithFees * outputReserve;
        uint denominator = (inputReserve * 100) + inputAmountwithFees;
        return numerator / denominator;
    }

    /**
     * @dev Swap ETH to CryptoDev tokens.
     * @param _minToken The minimum amount of CryptoDev tokens to receive in the swap.
     */
    function swapEthToToken(uint _minToken) external payable nonReentrant {
        uint tokenReserve = getReserve();
        uint tokenbought = getAmountofToken(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );
        if (tokenbought <= _minToken) {
            revert LessThanMinimiumTokenExpected();
        }
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, tokenbought);
    }

    /**
     * @dev Swap CryptoDev tokens to ETH.
     * @param _tokenSold The amount of CryptoDev tokens to be sold in the swap.
     * @param _mintETH The minimum amount of ETH to receive in the swap.
     */
    function swapTokenToETH(
        uint _tokenSold,
        uint _mintETH
    ) public nonReentrant {
        uint tokenRserve = getReserve();
        uint ethAmount = getAmountofToken(
            _tokenSold,
            tokenRserve,
            address(this).balance
        );

        if (ethAmount < _mintETH) {
            revert LessThanMinimiumETHExpected();
        }
        ERC20(cryptoDevTokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokenSold
        );

        (bool success, ) = msg.sender.call{value: ethAmount}("");
        if (!success) {
            revert TransferFailed();
        }
    }
}
