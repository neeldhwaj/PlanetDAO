pragma solidity ^0.4.0;

import "./DataStore.sol";


library ProjectsLibrary {

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    function projectCount(address projectStoreAddress) constant returns (uint count) {
        return DataStore(projectStoreAddress).count();
    }

    function createProject(address projectStoreAddress, string title, string description, uint budget) public {
        var projectStore = DataStore(projectStoreAddress);
        projectStore.increaseCount();
        var projectIndex = projectStore.count();

        projectStore.setIntValue(sha3('projectID', projectIndex), projectIndex);
        projectStore.setStringValue(sha3('projectTitle', projectIndex), title);
        projectStore.setStringValue(sha3('projectDescription', projectIndex), description);
        projectStore.setAddressValue(sha3('projectOwner', projectIndex),msg.sender);

        projectStore.setIntValue(sha3('projectBudget', projectIndex), budget);
        projectStore.setIntValue(sha3('projectDateCreated', projectIndex), now);
        projectStore.setIntValue(sha3('projectStatus', projectIndex), 0);
    }

    function getProject(address projectStoreAddress, uint projectIndex) constant returns (address projectOwner, 
                        uint projectBudget, uint projectMemberCount,
                        uint projectDateCreated, uint projectMilestoneDate, uint projectStatus) 
        {

        var projectStore = DataStore(projectStoreAddress);
        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        //var index = projectID;
        // Client/Front-end should get the title and description as getStringValue
        //projectTitle = projectStore.getStringValue(sha3('projectTitle', projectIndex));
        //projectDescription = projectStore.getStringValue(sha3('projectDescription', projectIndex));
        projectOwner = projectStore.getAddressValue(sha3('projectOwner', projectIndex));
        projectBudget = projectStore.getIntValue(sha3('projectBudget', projectIndex));
        projectMemberCount = projectStore.getIntValue(sha3('projectMemberCount', projectIndex));
        projectDateCreated = projectStore.getIntValue(sha3('projectDateCreated', projectIndex));
        projectMilestoneDate = projectStore.getIntValue(sha3('projectMilestoneDate', projectIndex));
        projectStatus = projectStore.getIntValue(sha3('projectStatus', projectIndex));
    }

//Remove Project
    function archiveProject(address projectStoreAddress, uint projectIndex) {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setIntValue(sha3('projectStatus', projectIndex), 2);

    }

//Add members to Project
    function addMemberToProject(address projectStoreAddress, uint name) {
        
    }

//Remove members from Project
    function removeMemberFromProject(address projectStoreAddress, uint name) {
        
    }

//Update Project budget

    function updateProjectBudget(address projectStoreAddress, uint projectIndex, uint projectBudget) {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setIntValue(sha3('projectBudget', projectIndex), projectBudget);

    }

//Update project title and description
    function updateProjectDetails(address projectStoreAddress, uint projectIndex, string projectTitle, string projectDescription) {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setStringValue(sha3('projectTitle', projectIndex), projectTitle);
        projectStore.setStringValue(sha3('projectDescription', projectIndex), projectDescription);
    }

//Add milestone to project

    function addProjectMilestone(address projectStoreAddress, string projectMilestone) {

    }

    // function borrowBook(address bookStoreAddress, uint id) {
    //     var bookStore = DataStore(bookStoreAddress);
    //     // Can't borrow book if passed value is not sufficient
    //     if (msg.value < 10**12) {
    //         Status(123);
    //         return;
    //     }
    //     // Can't borrow a non-existent book
    //     if (id > bookStore.count() || bookStore.getIntValue(id, sha3('state')) != 0) {
    //         Status(124);
    //         return;
    //     }
    //     // 50% value is shared with the owner
    //     var ownerShare = msg.value/2;
    //     if (!bookStore.getAddressValue(id, sha3('owner')).send(ownerShare)) {
    //         Status(125);
    //         return;
    //     }

    //     bookStore.setAddressValue(id, sha3('borrower'), msg.sender);
    //     bookStore.setIntValue(id, sha3('dateIssued'), now);
    //     bookStore.setIntValue(id, sha3('state'), 1);
    //     bookStore.triggerEvent("borrow", id, msg.sender, "", 0);
    // }

    // function returnBook(address bookStoreAddress, uint id) {
    //     var bookStore = DataStore(bookStoreAddress);
    //     if (id > bookStore.count() || bookStore.getIntValue(id, sha3('state')) == 0 || bookStore.getAddressValue(id, sha3('owner')) != msg.sender) {
    //         Status(126);
    //         return;
    //     }
    //     address borrower = bookStore.getAddressValue(id, sha3('borrower'));
    //     bookStore.setAddressValue(id, sha3('borrower'), 0x0);
    //     bookStore.setIntValue(id, sha3('dateIssued'), 0);
    //     bookStore.setIntValue(id, sha3('state'), 0);
    //     bookStore.triggerEvent("return", id, borrower, "", 0);
    // }

    // function rateBook(address bookStoreAddress, uint id, uint rating, uint oldRating, string comments) {
    //     var bookStore = DataStore(bookStoreAddress);
    //     if (id > bookStore.count() || rating < 1 || rating > 5) {
    //         Status(127);
    //         return;
    //     }
    //     if (oldRating == 0) {
    //         bookStore.setIntValue(id, sha3('reviewersCount'), bookStore.getIntValue(id, sha3('reviewersCount')) + 1);
    //         bookStore.setIntValue(id, sha3('totalRating'), bookStore.getIntValue(id, sha3('totalRating')) + rating);
    //     } else {
    //         bookStore.setIntValue(
    //             id, sha3('totalRating'),
    //             bookStore.getIntValue(id, sha3('totalRating')) + rating - oldRating
    //         );
    //     }
    //     bookStore.triggerEvent("rate", id, msg.sender, comments, rating);
    //     // All reviews are logged. Applications are responsible for eliminating duplicate ratings
    //     // and computing average rating.
    // }
}
