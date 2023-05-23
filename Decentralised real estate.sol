// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RealEstateTransfer {
    struct Transaction {
        address payable buyer;
        address payable seller;
        uint propertyValue;
        bool isSold;
    }
    
    mapping(uint => Transaction) private transactions;
    uint public transactionCount;
    
    event TransactionCompleted(address indexed _seller, address indexed _buyer, uint _value);
    
    modifier validTransaction(uint _transactionId) {
        require(_transactionId > 0 && _transactionId <= transactionCount, "Invalid transaction ID.");
        _;
    }
    
    constructor() {
        transactionCount = 0;
    }
    
    function initiateTransfer(address payable _buyer, address payable _seller, uint _propertyValue) external {
        require(_buyer != address(0), "Invalid buyer address.");
        require(_seller != address(0), "Invalid seller address.");
        
        transactionCount++;
        transactions[transactionCount] = Transaction(_buyer, _seller, _propertyValue, false);
    }
    
    function confirmPurchase(uint _transactionId) external payable validTransaction(_transactionId) {
        Transaction storage transaction = transactions[_transactionId];
        require(!transaction.isSold, "Property has already been sold.");
        require(msg.value >= transaction.propertyValue, "Insufficient funds.");
        
        transaction.seller.transfer(msg.value);
        
        transaction.isSold = true;
        
        emit TransactionCompleted(transaction.seller, transaction.buyer, transaction.propertyValue);
    }
    
    function printDocument(uint _transactionId) external view validTransaction(_transactionId) returns (bytes32) {
        Transaction storage transaction = transactions[_transactionId];
        require(transaction.isSold, "Property has not been sold yet.");
        
        // Generate PDF document with company logo and transaction details
        bytes32 documentHash = keccak256(abi.encodePacked(transaction.seller, transaction.buyer, transaction.propertyValue));
        
        // Add your logic here to generate and save the PDF document
        
        return documentHash;
    }
    
    function getLastTransactionId() external view returns (uint) {
        return transactionCount;
    }
}
