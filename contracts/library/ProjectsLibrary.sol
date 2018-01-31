pragma solidity 0.4.18;

import "../DataStore.sol";


library ProjectsLibrary {

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    function projectCount(address projectStoreAddress) public constant returns (uint count) {
        return DataStore(projectStoreAddress).count();
    }

    function createProject(address projectStoreAddress, string title, string description, uint budget) public {
        var projectStore = DataStore(projectStoreAddress);
        projectStore.increaseCount();
        var projectIndex = projectStore.count();

        projectStore.setIntValue(keccak256("projectID", projectIndex), projectIndex);
        projectStore.setStringValue(keccak256("projectTitle", projectIndex), title);
        projectStore.setStringValue(keccak256("projectDescription", projectIndex), description);
        projectStore.setAddressValue(keccak256("projectOwner", projectIndex), msg.sender);

        projectStore.setIntValue(keccak256("projectBudget", projectIndex), budget);
        projectStore.setIntValue(keccak256("projectDateCreated", projectIndex), now);
        projectStore.setIntValue(keccak256("projectStatus", projectIndex), 0);
    }

    function getProject(address projectStoreAddress, uint projectIndex) public constant returns (address projectOwner,
                        uint projectBudget, uint projectMemberCount,
                        uint projectDateCreated, uint projectMilestoneDate, uint projectStatus)
        {

        var projectStore = DataStore(projectStoreAddress);
        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        //var index = projectID;
        // Client/Front-end should get the title and description as getStringValue
        //projectTitle = projectStore.getStringValue(keccak256("projectTitle", projectIndex));
        //projectDescription = projectStore.getStringValue(keccak256("projectDescription", projectIndex));
        projectOwner = projectStore.getAddressValue(keccak256("projectOwner", projectIndex));
        projectBudget = projectStore.getIntValue(keccak256("projectBudget", projectIndex));
        projectMemberCount = projectStore.getIntValue(keccak256("projectMemberCount", projectIndex));
        projectDateCreated = projectStore.getIntValue(keccak256("projectDateCreated", projectIndex));
        projectMilestoneDate = projectStore.getIntValue(keccak256("projectMilestoneDate", projectIndex));
        projectStatus = projectStore.getIntValue(keccak256("projectStatus", projectIndex));
    }

//Remove Project
    function archiveProject(address projectStoreAddress, uint projectIndex) public {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setIntValue(keccak256("projectStatus", projectIndex), 2);

    }

//Add members to Project
    function addMemberToProject(address projectStoreAddress, uint name) public pure {

    }

//Remove members from Project
    function removeMemberFromProject(address projectStoreAddress, uint name) public pure {

    }

//Update Project budget
    function updateProjectBudget(address projectStoreAddress, uint projectIndex, uint projectBudget) public {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setIntValue(keccak256("projectBudget", projectIndex), projectBudget);

    }

//Update project title and description
    function updateProjectDetails(address projectStoreAddress,
                                    uint projectIndex,
                                    string projectTitle,
                                    string projectDescription)
    public
    {
        var projectStore = DataStore(projectStoreAddress);

        if (projectIndex < 1 || projectIndex > projectStore.count()) {
            return;
        }

        projectStore.setStringValue(keccak256("projectTitle", projectIndex), projectTitle);
        projectStore.setStringValue(keccak256("projectDescription", projectIndex), projectDescription);
    }

//Add milestone to project

    /* function addProjectMilestone(address projectStoreAddress, string projectMilestone) public pure {

    } */

    // function borrowBook(address bookStoreAddress, uint id) public {
    //     var bookStore = DataStore(bookStoreAddress);
    //     // Can't borrow book if passed value is not sufficient
    //     if (msg.value < 10**12) {
    //         Status(123);
    //         return;
    //     }
    //     // Can't borrow a non-existent book
    //     if (id > bookStore.count() public || bookStore.getIntValue(id, keccak256("state")) != 0) {
    //         Status(124);
    //         return;
    //     }
    //     // 50% value is shared with the owner
    //     var ownerShare = msg.value/2;
    //     if (!bookStore.getAddressValue(id, keccak256("owner")).send(ownerShare)) {
    //         Status(125);
    //         return;
    //     }

    //     bookStore.setAddressValue(id, keccak256("borrower"), msg.sender);
    //     bookStore.setIntValue(id, keccak256("dateIssued"), now);
    //     bookStore.setIntValue(id, keccak256("state"), 1);
    //     bookStore.triggerEvent("borrow", id, msg.sender, "", 0);
    // }

    // function returnBook(address bookStoreAddress, uint id) public {
    //     var bookStore = DataStore(bookStoreAddress);
    //     if (id > bookStore.count() public ||
    //         bookStore.getIntValue(id, keccak256("state')) == 0 ||
    //         bookStore.getAddressValue(id, keccak256('owner")) != msg.sender) {
    //         Status(126);
    //         return;
    //     }
    //     address borrower = bookStore.getAddressValue(id, keccak256("borrower"));
    //     bookStore.setAddressValue(id, keccak256("borrower"), 0x0);
    //     bookStore.setIntValue(id, keccak256("dateIssued"), 0);
    //     bookStore.setIntValue(id, keccak256("state"), 0);
    //     bookStore.triggerEvent("return", id, borrower, "", 0);
    // }

    // function rateBook(address bookStoreAddress, uint id, uint rating, uint oldRating, string comments) public {
    //     var bookStore = DataStore(bookStoreAddress);
    //     if (id > bookStore.count() public || rating < 1 || rating > 5) {
    //         Status(127);
    //         return;
    //     }
    //     if (oldRating == 0) {
    //         bookStore.setIntValue(id, keccak256("reviewersCount'),
    //                               bookStore.getIntValue(id, keccak256('reviewersCount")) + 1);
    //         bookStore.setIntValue(id, keccak256("totalRating'),
    //                               bookStore.getIntValue(id, keccak256('totalRating")) + rating);
    //     } else {
    //         bookStore.setIntValue(
    //             id, keccak256("totalRating"),
    //             bookStore.getIntValue(id, keccak256("totalRating")) + rating - oldRating
    //         );
    //     }
    //     bookStore.triggerEvent("rate", id, msg.sender, comments, rating);
    //     // All reviews are logged. Applications are responsible for eliminating duplicate ratings
    //     // and computing average rating.
    // }
}
