// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Hacking2024 is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    string public ipfs = "ipfs://bafkreihl2cjv6u45mjpqmkhqvxmfvmue6lplwwe7o7jgwjk45kjr4vr67m";

    constructor()
        ERC721("Hacking 2024", "ETHKipu")
        Ownable(msg.sender)
    {}

    function _mint(address to) internal virtual {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, ipfs);
    }

    function setUri(string calldata _uri) external onlyOwner {
        ipfs = _uri;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

contract Grader is Hacking2024 {

    mapping (address=>uint256) public balance;
    mapping (address=>uint256) public counter;
    mapping(string => uint256) public students;
    mapping(address => bool) public isGraded;
    uint256 public studentCounter;
    uint256 public divisor=5;
    uint256 public deadline=10000000000000000000000;
    mapping(address => uint8) public foo;

    modifier onlyCounter() {
        require(counter[msg.sender]>1,"not yet");
        _;
    }

    constructor() payable {}

    //ipfs://QmPvi3dzqaw2NTRcsqV1gBQsukNy3r6TPqXUWvNeJ8kiMx
    function retrieve() external payable {
        require(msg.value > 3,"not enough money");
        counter[msg.sender]++;
        require(counter[msg.sender]<4);
        (bool sent, ) = payable(msg.sender).call{value: 1, gas: gasleft()}("");
        require(sent, "Failed to send Ether");
        if(counter[msg.sender]<2) {
            counter[msg.sender]=0;
        }
        foo[tx.origin] = 1;
    }

    function retrieve2() external payable {
        require(msg.value > 3,"not enough money");
        counter[msg.sender]++;
        foo[msg.sender] = 2;
    }    

    function mint(address to) external onlyCounter{
        _mint(to);
    }

    function gradeMe(string calldata name) public {
        require(block.timestamp<deadline,"The end");
        require(balanceOf(msg.sender)>=1,"Not yet");
        uint256 _grade = studentCounter/divisor;
        if(foo[msg.sender] == 2) {   
            if(_grade <= 100) {
                _grade = 100 - _grade;
            }
            if(_grade < 70) {
                _grade = 70;
            }
            if(_grade == 100) {
                _grade = 90;
            }
        }
        if(foo[msg.sender] == 1) {
            _grade = 100;
        }
        require(students[name]==0,"student already exists");
        require(isGraded[msg.sender]==false, "already graded");
        isGraded[msg.sender] = true;
        students[name] = _grade;
    }

    function _mint(address to) internal override {
        super._mint(to);
    }


    // Setter para divisor
    function setDivisor(uint256 _divisor) public onlyOwner {
        divisor = _divisor;
    }

    // Setter para deadline
    function setDeadline(uint256 _deadline) public onlyOwner {
        deadline = _deadline;
    }

}