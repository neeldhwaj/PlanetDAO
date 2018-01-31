// An iterable data stored designed to be eternal.
// A more appropriate name could be IterableDataStore, but that's a mouthful.
// Create new instances for each logical entity e.g. one for books, one for members and so on.
// As is true for all Ethereum contracts, keep the contract addresses very safe, else you will lose all data.

pragma solidity 0.4.18;

import "./helper_contracts/zeppelin/lifecycle/Killable.sol";


contract DataStore is Killable {
    uint public count;

    function increaseCount() public {
        // Invoke this function to increase the counter
        // For one instance, count will work as subset memberIndex
        count++;
    }

    function decreaseCount() public {
        // Invoke this function to decrease the counter
        // Invoke this function before adding a new record.
        count--;
    }

    mapping (bytes32 => address) public addressStorage;
    mapping (bytes32 => uint) public intStorage;
    mapping (bytes32 => string) public stringStorage;
    // An example Member Data Store:
    // {1: {'name': 'John Doe', 'email': 'john.doe@example.com'}}
    // {2: {'name': 'Johnny Appleseed', 'email': 'johnny.appleseed@icloud.com', 'address': '1, Infinite Loop'}}

    function getAddressValue(bytes32 key) public constant returns (address) {
        return addressStorage[key];
    }

    function setAddressValue(bytes32 key, address value) public {
        addressStorage[key] = value;
    }

    function getIntValue(bytes32 key) public constant returns (uint) {
        return intStorage[key];
    }

    function setIntValue(bytes32 key, uint value) public {
        intStorage[key] = value;
    }

    function getStringValue(bytes32 key) public constant returns (string) {
        // This function cannot be used by other contracts or libraries due to an EVM restriction
        // on contracts reading variable-sized data from other contracts.
        return stringStorage[key];
    }

    function setStringValue(bytes32 key, string value) public {
        stringStorage[key] = value;
    }

    mapping(bytes32 => mapping (address => uint)) private addressIndex;
    mapping(bytes32 => mapping (bytes32 => uint)) private bytes32Index;
    mapping(bytes32 => mapping (uint => uint)) private intIndex;

    function getAddressIndex(bytes32 indexName, address key) public constant returns (uint) {
        return addressIndex[indexName][key];
    }

    function setAddressIndex(bytes32 indexName, address key, uint index) public {
        addressIndex[indexName][key] = index;
    }

    function getBytes32Index(bytes32 indexName, bytes32 key) public constant returns (uint) {
        return bytes32Index[indexName][key];
    }

    function setBytes32Index(bytes32 indexName, bytes32 key, uint index) public {
        bytes32Index[indexName][key] = index;
    }

    function getIntIndex(bytes32 indexName, uint key) public constant returns (uint) {
        return intIndex[indexName][key];
    }

    function setIntIndex(bytes32 indexName, uint key, uint index) public {
        intIndex[indexName][key] = index;
    }
}
