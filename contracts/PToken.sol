/*
Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
.*/
pragma solidity ^0.4.8;

// 0x710a257a58747569215c81972de0c7c0c187b23d

/*
    Balance

    "Balance", address                          uint
    "OnHold", address                           uint
    "Allowed", ownerAddress, spenderAddress     uint
*/

import "./Token.sol";
import "./DataStore.sol";

contract PToken is Token {

    address public storageAddress;

    function PToken(uint _initialAmount, address _storage) {
        storageAddress = _storage;
        DataStore(storageAddress).setIntValue(sha3("Balance", msg.sender), _initialAmount);
        totalSupply = _initialAmount;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

        if (isLocked(msg.sender)) { return false; }

        var store = DataStore(storageAddress);
        var fromBalance = balanceOf(msg.sender);
        var toBalance = balanceOf(_to);

        if (fromBalance >= _value && _value > 0) {
            store.setIntValue(sha3("Balance", msg.sender), fromBalance - _value);
            if (isLocked(_to)) { 
                addOnHoldBalance(_to, _value); 
            } else { 
                store.setIntValue(sha3("Balance", _to), toBalance + _value); 
            }
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

        if (isLocked(msg.sender)) { return false; }

        var store = DataStore(storageAddress);
        var fromBalance = balanceOf(_from);
        var toBalance = balanceOf(_to);
        var allowed = allowance(_from, msg.sender);

        if (fromBalance >= _value && allowed >= _value && _value > 0) {
            store.setIntValue(sha3("Balance", _from), fromBalance - _value);
            if (isLocked(_to)) { 
                addOnHoldBalance(_to, _value); 
            } else { 
                store.setIntValue(sha3("Balance", _to), toBalance + _value); 
            }
            store.setIntValue(sha3("Allowed", _from, msg.sender), allowed - _value);
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return DataStore(storageAddress).getIntValue(sha3("Balance", _owner));
    }

    function onHoldBalanceOf(address _owner) constant returns (uint256 balance) {
        return DataStore(storageAddress).getIntValue(sha3("OnHold", _owner));
    }

    function addOnHoldBalance(address _owner, uint256 _value) returns (bool success) {
        var newBalance = onHoldBalanceOf(_owner) + _value;
        DataStore(storageAddress).setIntValue(sha3("OnHold", _owner), newBalance);
        return true;
    }

    function releaseHold(address _owner) returns (bool success) {
        var store = DataStore(storageAddress);
        var onHoldBalance = onHoldBalanceOf(_owner);

        if (onHoldBalance > 0) {
            var newBalance = balanceOf(_owner) + onHoldBalance;
            store.setIntValue(sha3("OnHold", _owner), uint256(0));
            store.setIntValue(sha3("Balance", _owner), newBalance);
        }

        return true;
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        var newAllowed = allowance(msg.sender, _spender) + _value;
        DataStore(storageAddress).setIntValue(sha3("Allowed", msg.sender, _spender), newAllowed);
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return DataStore(storageAddress).getIntValue(sha3("Allowed", _owner, _spender));
    }

    function isLocked(address _owner) constant returns (bool locked) {
        var firstCloseTime = DataStore(storageAddress).getIntValue(sha3("Vote", _owner, uint256(0), "nextTimestamp"));

        if (firstCloseTime == 0 || firstCloseTime > now) { return false; }
        return true;
    }

    // mapping (address => uint256) balances;
    // mapping (address => mapping (address => uint256)) allowed;
}
