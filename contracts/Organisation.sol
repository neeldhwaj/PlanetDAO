pragma solidity ^0.4.8;

import "./helper_contracts/strings.sol";
import "./helper_contracts/StringLib.sol";
import "./helper_contracts/zeppelin/ownership/Ownable.sol";

import "./DataStore.sol";
import "./MembersLibrary.sol";
import "./ProjectsLibrary.sol";


contract Organisation is Ownable {
    using strings for *;
    // using BooksLibrary for address;
    using MembersLibrary for address;
    using ProjectsLibrary for address;

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    address public memberStore;
    address public projectStore;
    address public taskStore;

    // modifier onlyMember {
    //     var index = DataStore(memberStore).getAddressIndex('account', msg.sender);
    //     var state = DataStore(memberStore).getIntValue(index, 'state');
    //     if (index != 0 && state == 0) {
    //         _;
    //     } else {
    //         Status(100);
    //     }
    // }

    function Organisation() payable {
        // TODO Check for funds being transferred
        // The contract could also be funded after instantiation through sendTransaction.
    }

    function setDataStore(address _memberStore, address _projectStore, address _taskStore) onlyOwner {
        if (_memberStore == 0x0) {
            memberStore = new DataStore();
        } else {
            memberStore = _memberStore;
        }
        if (_projectStore == 0x0) {
            projectStore = new DataStore();
        } else {
            projectStore = _projectStore;
        }
        if (_taskStore == 0x0) {
            taskStore = new DataStore();
        } else {
            taskStore = _taskStore;
        }
    }

    function getDataStore() constant returns (address, address, address) {
        return (memberStore, projectStore, taskStore);
    }

    //////////////////////
    // Member Functions //
    //////////////////////

    function memberCount() constant returns (uint) {
        return memberStore.memberCount();
    }

    function addMember(address account, uint index) {
        memberStore.addMember(account, index);
    }

    function removeMember(address account)  {
        memberStore.removeMember(account);
    }

    function getMember(uint index) constant returns (string memberString) {
        if (index < 1) {
            return;
        }
        var (account, state, dateAdded) = memberStore.getMember(index);
        if (account == 0x0) {
            return;
        }
        var parts = new strings.slice[](4);
        parts[0] = StringLib.uintToString(index).toSlice();
        parts[1] = StringLib.addressToString(account).toSlice();
        parts[2] = StringLib.uintToString(state).toSlice();
        parts[3] = StringLib.uintToString(dateAdded).toSlice();
        memberString = ";".toSlice().join(parts);
        return memberString;
    }

    function getAllMembers() constant onlyOwner returns (string memberString, uint8 count) {
        string memory member;
        for (uint i = 1; i <= memberStore.memberCount(); i++) {
            // subset memberIndex key is always stored as "member_account"
            var index = DataStore(memberStore).getIntIndex(sha3('memberIndex'), i);
            member = getMember(index);
            count++;
            if (memberString.toSlice().equals("".toSlice())) {
                memberString = member;
            } else {
                memberString = memberString.toSlice().concat('|'.toSlice()).toSlice().concat(member.toSlice());
            }
        }
    }

    ///////////////////////
    // Project Functions //
    ///////////////////////

    function projectCount() constant returns (uint) {
        return projectStore.projectCount();
    }

    function createProject(string projectTitle, string projectDescription, uint projectBudget) public {
        projectStore.createProject(projectTitle, projectDescription, projectBudget);
    }

    function getProject(uint projectIndex) constant returns (string projectTitle,
                        string projectDescription, address projectOwner, uint projectBudget, uint projectMemberCount,
                        uint projectDateCreated, uint projectMilestoneDate, uint projectStatus) {
        //return projectStore.getProject(projectIndex);
    }

    function archiveProject(uint projectIndex) {
        projectStore.archiveProject(projectIndex);
    }

    function updateProjectBudget(uint projectIndex, uint projectBudget) {
        projectStore.updateProjectBudget(projectIndex, projectBudget);
    }

    function updateProjectDetails(uint projectIndex, string projectTitle, string projectDescription) {
        projectStore.updateProjectDetails(projectIndex, projectTitle, projectDescription);
    }

    // function getBook(uint id) constant returns (string bookString) {
    //     if (id < 1 || id > memberStore.bookCount()) {
    //         return;
    //     }
    //     var (i, isbn, state, owner, borrower, dateAdded, dateIssued, totalRating, reviewersCount) = memberStore.getBook(id);
    //     var parts = new strings.slice[](9);
    //     parts[0] = StringLib.uintToString(i).toSlice();
    //     parts[1] = StringLib.uintToString(isbn).toSlice();
    //     parts[2] = StringLib.uintToString(state).toSlice();
    //     parts[3] = StringLib.addressToString(owner).toSlice();
    //     parts[4] = StringLib.addressToString(borrower).toSlice();
    //     parts[5] = StringLib.uintToString(dateAdded).toSlice();
    //     parts[6] = StringLib.uintToString(dateIssued).toSlice();
    //     parts[7] = StringLib.uintToString(totalRating).toSlice();
    //     parts[8] = StringLib.uintToString(reviewersCount).toSlice();
    //     bookString = ";".toSlice().join(parts);
    //     return bookString;
    // }

    // function getAllBooks() constant returns (string bookString, uint8 count) {
    //     string memory book;
    //     for (uint i = 1; i <= memberStore.bookCount(); i++) {
    //         book = getBook(i);
    //         count++;
    //         if (bookString.toSlice().equals("".toSlice())) {
    //             bookString = book;
    //         } else {
    //             bookString = bookString.toSlice().concat('|'.toSlice()).toSlice().concat(book.toSlice());
    //         }
    //     }
    // }

    // function borrowBook(uint id) payable {
    //     memberStore.borrowBook(id, msg.sender);
    // }

    // function returnBook(uint id) {
    //     memberStore.returnBook(id, msg.sender);
    // }

    // function rateBook(uint id, uint rating, uint oldRating, string comments)  {
    //     memberStore.rateBook(id, rating, oldRating, comments, msg.sender);
    // }


    // ////////////////////
    // // Task Functions //
    // ////////////////////


    function kill(address upgradedOrganisation) {
        DataStore(memberStore).transferOwnership(upgradedOrganisation);
        DataStore(memberStore).transferOwnership(upgradedOrganisation);
        selfdestruct(upgradedOrganisation);
    }
}