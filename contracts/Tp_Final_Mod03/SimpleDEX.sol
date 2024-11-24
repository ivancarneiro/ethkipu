// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SimpleDEX
 * @dev A simple decentralized exchange implementation that enables swapping between two ERC20 tokens
 * using the constant product formula (x+dx)(y-dy)=xy for price calculation.
 * @notice The contract implements security measures including reentrancy protection and access control.
 * @author Ivan Carneiro
 */

contract SimpleDEX is Ownable, ReentrancyGuard {
    /// @notice The first token in the trading pair
    IERC20 public tokenA;

    /// @notice The second token in the trading pair
    IERC20 public tokenB;

    // Events
    /**
     * @dev Emitted when liquidity is added to the pool by the owner
     * @param provider Address of the liquidity provider (owner)
     * @param amountA Amount of TokenA added
     * @param amountB Amount of TokenB added
     */
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);

    /**
     * @dev Emitted when liquidity is removed from the pool by the owner
     * @param provider Address of the liquidity provider (owner)
     * @param amountA Amount of TokenA removed
     * @param amountB Amount of TokenB removed
     */
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);

    /**
     * @dev Emitted when a token swap occurs
     * @param user Address of the user performing the swap
     * @param tokenIn Address of the token being sold
     * @param tokenOut Address of the token being bought
     * @param amountIn Amount of tokens being sold
     * @param amountOut Amount of tokens being bought
     */
    event TokenSwapped(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    /**
     * @dev Constructor initializes the DEX with addresses of both tokens
     * @param _tokenA Address of the first token
     * @param _tokenB Address of the second token
     */
    constructor(address _tokenA, address _tokenB) Ownable(msg.sender) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token addresses");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    /**
     * @dev Returns the current reserves of both tokens in the pool
     * @return reserveA Current balance of TokenA
     * @return reserveB Current balance of TokenB
     */
    function getReserves() public view returns (uint256 reserveA, uint256 reserveB) {
        reserveA = tokenA.balanceOf(address(this));
        reserveB = tokenB.balanceOf(address(this));
    }

    /**
     * @dev Allows only the owner to add liquidity to the pool
     * @param amountA Amount of TokenA to add
     * @param amountB Amount of TokenB to add
     * @notice Only the owner can call this function
     * @notice Tokens must be approved before calling this function
     */
    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        // Transfer tokens to the contract
        require(tokenA.transferFrom(owner(), address(this), amountA), "Transfer of tokenA failed");
        require(tokenB.transferFrom(owner(), address(this), amountB), "Transfer of tokenB failed");

        emit LiquidityAdded(owner(), amountA, amountB);
    }

    /**
     * @dev Allows only the owner to remove liquidity from the pool
     * @param amountA Amount of TokenA to remove
     * @param amountB Amount of TokenB to remove
     * @notice Only the owner can call this function
     */
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        (uint256 reserveA, uint256 reserveB) = getReserves();
        require( amountA <= reserveA && amountB <= reserveB, "Insufficient liquidity");

        // Transfer tokens back to the owner
        require(tokenA.transfer(owner(), amountA), "Transfer of tokenA failed");
        require(tokenB.transfer(owner(), amountB), "Transfer of tokenB failed");

        emit LiquidityRemoved(owner(), amountA, amountB);
    }

    /**
     * @dev Swaps TokenA for TokenB using the constant product formula
     * @param amountAIn Amount of TokenA to swap
     * @return amountBOut Amount of TokenB received
     * @notice Tokens must be approved before calling this function
     */
    function swapAforB(uint256 amountAIn) external returns (uint256 amountBOut) {
        require(amountAIn > 0, "Amount must be greater than 0");

        (uint256 reserveA, uint256 reserveB) = getReserves();
        require(reserveA > 0 && reserveB > 0, "Insufficient liquidity");

        // Calculate output amount using constant product formula
        // (x + dx)(y - dy) = xy
        // dy = (y * dx) / (x + dx)
        amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);

        require(amountBOut > 0, "Insufficient output amount");
        require(amountBOut < reserveB, "Insufficient liquidity");

        require(tokenA.transferFrom(owner(), address(this), amountAIn), "Transfer of tokenA failed");
        require(tokenB.transfer(owner(), amountBOut), "Transfer of tokenB failed");

        emit TokenSwapped(owner(), address(tokenA), address(tokenB), amountAIn, amountBOut);
        return amountBOut;
    }

    /**
     * @dev Swaps TokenB for TokenA using the constant product formula
     * @param amountBIn Amount of TokenB to swap
     * @return amountAOut Amount of TokenA received
     * @notice Tokens must be approved before calling this function
     */
    function swapBforA(uint256 amountBIn) external nonReentrant returns (uint256 amountAOut) {
        require(amountBIn > 0, "Amount must be greater than 0");

        (uint256 reserveA, uint256 reserveB) = getReserves();
        require(reserveA > 0 && reserveB > 0, "Insufficient liquidity");

        // Calculate output amount using constant product formula
        amountAOut = (reserveA * amountBIn) / (reserveB + amountBIn);

        require(amountAOut > 0, "Insufficient output amount");
        require(amountAOut < reserveA, "Insufficient liquidity");

        require(tokenB.transferFrom(owner(), address(this), amountBIn), "Transfer of tokenB failed");
        require(tokenA.transfer(owner(), amountAOut), "Transfer of tokenA failed");

        emit TokenSwapped(owner(), address(tokenB), address(tokenA), amountBIn, amountAOut);
        return amountAOut;
    }

    /**
     * @dev Returns the current price of the specified token in terms of the other token
     * @param _token Address of the token to get the price for
     * @return Price of the token with 18 decimal places
     * @notice Price is expressed as how many of the other token you get for 1 of this token
     */
    function getPrice(address _token) external view returns (uint256) {
        require(_token == address(tokenA) || _token == address(tokenB), "Invalid token address");

        (uint256 reserveA, uint256 reserveB) = getReserves();
        require(reserveA > 0 && reserveB > 0, "Empty reserves");

        // Returns price normalized to 18 decimal places
        if (_token == address(tokenA)) {
            return (reserveB * 1e18) / reserveA; // Price of TokenA in terms of TokenB
        } else {
            return (reserveA * 1e18) / reserveB; // Price of TokenB in terms of TokenA
        }
    }
}