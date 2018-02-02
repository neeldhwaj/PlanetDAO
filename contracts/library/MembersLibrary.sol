pragma solidity 0.4.18;

import "../helper_contracts/strings.sol";
import "../helper_contracts/StringLib.sol";

import "../DataStore.sol";


library MembersLibrary {

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    // Member has following states: 0 (Active), 1 (Inactive)
    function memberCount(address memberStoreAddress) public constant returns (uint count) {
        return DataStore(memberStoreAddress).count();
    }

    function addMember(address memberStoreAddress, address account, uint accountIndex) public {
        var memberStore = DataStore(memberStoreAddress);
        if (accountIndex == 0) {
            Status(100);
        }
        // if (accountIndex == emailIndex && accountIndex != 0) {
        //     // if member is already registered with given info
        //     memberStore.setIntValue(accountIndex, "state", 0);
        //     Status(102);
        //     return;
        // }
        // if (accountIndex != 0 && emailIndex != 0 && emailIndex != accountIndex) {
        //     // provided account and email already registered but with different users
        //     Status(103);
        //     return;
        // }
        // if (accountIndex == 0 && emailIndex != 0) {
        //     // email is already registered
        //     Status(104);
        //     return;
        // }
        // if (accountIndex != 0 && emailIndex == 0) {
        //     // account is already registered
        //     Status(105);
        //     return;
        // }
        memberStore.increaseCount();
        uint memberIndex = memberStore.count();

        memberStore.setIntValue(keccak256("dateAdded", accountIndex), now);
        // // setting state of the member to 0 is not needed as the default value for a uint when it is declared is 0.
        //memberStore.setIntValue(keccak256("state", accountIndex), 0);
        // mapping subset memberIndex to superset index
        memberStore.setIntIndex(keccak256("memberIndex"), memberIndex, accountIndex);
        memberStore.setAddressValue(keccak256("account", accountIndex), account);
        memberStore.setAddressIndex(keccak256("accountIndex"), account, accountIndex);
    }

    function removeMember(address memberStoreAddress, address account) public {
        var memberStore = DataStore(memberStoreAddress);
        // Deactivate member
        var accountIndex = memberStore.getAddressIndex(keccak256("accountIndex"), account);
        if (accountIndex != 0) {
            memberStore.setIntValue(keccak256("state", accountIndex), 1);
            memberStore.decreaseCount();
        }
    }

    function getMember(address memberStoreAddress, uint index)
    public
    constant
    returns (address account, uint state, uint dateAdded)
    {
        var memberStore = DataStore(memberStoreAddress);
        if (index < 1) {
            return;
        }
        account = memberStore.getAddressValue(keccak256("account", index));
        if (account == 0x0) {
            return;
        }

        /* account = memberStore.getAddressValue(keccak256("account", index)); */
        state = memberStore.getIntValue(keccak256("state", index));
        dateAdded = memberStore.getIntValue(keccak256("dateAdded", index));
    }
}
