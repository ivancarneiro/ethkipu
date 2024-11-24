// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)


/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: contracts/Tp_Final_Mod03/SimpleDEX.sol






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

        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer of tokenA failed");
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer of tokenB failed");

        emit TokenSwapped(msg.sender, address(tokenA), address(tokenB), amountAIn, amountBOut);
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

        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "Transfer of tokenB failed");
        require(tokenA.transfer(msg.sender, amountAOut), "Transfer of tokenA failed");

        emit TokenSwapped(msg.sender, address(tokenB), address(tokenA), amountBIn, amountAOut);
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