// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Swapico {

    address public immutable synthetico;
    address public immutable authentico;
    uint256 public immutable inicio;
    
    event purchased(address indexed _purchaser, uint256 indexed _tokens);
    
    constructor(address _synthetico, address _authentico, uint256 _inicio) public {
        synthetico = _synthetico;
        authentico = _authentico;
        inicio = _inicio;
    }
    
    function purchase(address assetAddress, uint256 amountAsset) public {        
        require(block.timestamp >= inicio, 'purchase: too soon');
        require(assetAddress == synthetico, 'purchase: invalid payment asset provided');
        require(IERC20(authentico).balanceOf(address(this)) >= amountAsset, 'purchase: insufficient liquidity');
        _purchase(assetAddress, amountAsset);
    }
    
    function _purchase(address assetAddress, uint256 assetAmount) internal {
        IERC20(assetAddress).burnFrom(msg.sender, assetAmount);
        IERC20(authentico).transfer(msg.sender, assetAmount);
        
        emit purchased(msg.sender, assetAmount);
    }
}
