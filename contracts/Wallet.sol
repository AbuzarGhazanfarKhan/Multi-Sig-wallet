// SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Wallet{
    address [] public approvers;
    uint public criteria;
    struct Transfer{
        uint id;
        uint amount;
        address payable to;
        uint approvals;// number of approvers this transfer have
        bool sent;
    }
    Transfer[] public transfers;
    // mapping of who approved the transfer
    // ifan address has already approved the mapping of transfer
    mapping(address => mapping(uint => bool)) public approvals;

    // container to hold all the transfers
    // mapping(uint => Transfer) public transfers;// uint is id of transfer
    uint public nextId;
    constructor(address[] memory _approvers, uint _criteria) {
        approvers=_approvers;
        criteria=_criteria;
    }

// extarnals can be accesed outside smart contract like from web3.js etc
    function getApprovers() external view returns (address[] memory){
        return approvers;
    }
       function getTransfer() external view returns (Transfer[] memory){
        return transfers;
    }
    function createTransfer(uint amount, address payable to) external onlyApprovers() {
        transfers[nextId]=Transfer(
            nextId,
            amount,
            to,
            0,
            false
        );
        nextId++;
    }
    // takes an id to be approved
    function approveTransfer(uint id) external onlyApprovers() {
        require(!transfers[id].sent,"Transfer has already been sent");
        require(approvals[msg.sender][id] == false,"Cannot approve twice");
        transfers[id].approvals++;
        if(transfers[id].approvals >= criteria){
            transfers[id].sent =true;
            address payable to= transfers[id].to;
            uint amount=transfers[id].amount;
            to.transfer(amount);
        }
    }

// send ethers in this wallet smartContract
    receive() external payable {}

    // modifier for only approvers only they can call functions

    modifier onlyApprovers(){
        bool allowed=false;
        for (uint i=0; i<approvers.length;i++){
            if(approvers[i] == msg.sender){
                allowed=true;
            }
        }
        require(allowed == true,"Only approvers are allowed");
        _;
    }


}