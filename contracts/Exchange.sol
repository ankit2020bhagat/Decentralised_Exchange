// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    
    address public cryptoDevTokenAddress;

    constructor(address _cryptoDevToken) ERC20("CryptoDev Lp Token","CDLT"){
        if(_cryptoDevToken == address(0)){
            revert();
        }
        cryptoDevTokenAddress = _cryptoDevToken;
    }

    function getReserve() public view  returns(uint){
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    } 

    function addLiquidity(uint _amount)external payable returns(uint){
         uint liquidity;
         uint ethBalance = address(this).balance;
         uint cryptoDevReserve = getReserve();

         ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

         if(cryptoDevReserve == 0){
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);

            liquidity = ethBalance;
            _mint(msg.sender,liquidity);
         }
         else{
            uint ethReserve = address(this).balance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevReserve)/ethReserve;

            if(_amount < cryptoDevTokenAmount){
                revert();
            }
            cryptoDevToken.transferFrom(msg.sender, address(this), cryptoDevTokenAmount);
            liquidity = (totalSupply() * msg.value )/ethReserve;
            _mint(msg.sender,liquidity);
         }
         return liquidity;


    }

    function removeLiquidity(uint _amount )external returns(uint,uint) {
        if(_amount <=0){
            revert();
        }
        uint ethReserve = address(this).balance;
        uint ethAmount = (_amount * ethReserve)/totalSupply();
        uint cryptoDevTokenAmount = (_amount * getReserve())/totalSupply();
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
        return (ethAmount, cryptoDevTokenAmount);
    }

    function getAmountofToken(
        uint inputAmount,uint inputReserve,uint outputReserve)
         public pure returns(uint){
         if(inputAmount <=0 && outputReserve <=0){
            revert();
         }
         uint inputAmountwithFees = inputAmount * 99;
         uint numerator = inputAmountwithFees * outputReserve ;
         uint denominator = (inputReserve * 100) + inputAmountwithFees;
         return numerator /denominator;
    }

    function ethToCryptoDevToken(uint _mintToken) external payable {
        uint tokenReserve = getReserve();
        uint tokenbought = getAmountofToken(msg.value,address(this).balance - msg.value,tokenReserve);
        if (tokenbought <= _mintToken) {
            revert();
        }
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, tokenbought);
    }

    function cryptoDevTokentoeth(uint _tokenSold,uint _mintETH) public {
        uint tokenRserve = getReserve();
        uint ethAmount  = getAmountofToken(_tokenSold, tokenRserve, address(this).balance);

        if(ethAmount < _mintETH){
            revert();
        }
        ERC20(cryptoDevTokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokenSold
        );

        payable(msg.sender).transfer(ethAmount);
    }
         
}