pragma solidity 0.4.18;

import "../DataStore.sol";


library TasksLibrary {

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    function taskCount(address taskStoreAddress) public constant returns (uint count) {
        return DataStore(taskStoreAddress).count();
    }

    function createTask (address taskStoreAddress, string title, string description, string tags, uint budget) public {
        var taskStore = DataStore(taskStoreAddress);
        taskStore.increaseCount();
        var taskIndex = taskStore.count();

        taskStore.setIntValue(keccak256("taskID", taskIndex), taskIndex);
        taskStore.setStringValue(keccak256("taskTitle", taskIndex), title);
        taskStore.setStringValue(keccak256("taskDescription", taskIndex), description);
        taskStore.setAddressValue(keccak256("taskOwner", taskIndex), msg.sender);
        taskStore.setStringValue(keccak256("tags", taskIndex), tags);
        taskStore.setIntValue(keccak256("taskBudget", taskIndex), budget);
        taskStore.setIntValue(keccak256("taskDateCreated", taskIndex), now);
        taskStore.setIntValue(keccak256("taskStatus", taskIndex), 0);
    }

    function getTask(address taskStoreAddress, uint taskIndex)
    public
    constant
    returns (
    address taskOwner,
    uint taskBudget,
    uint taskMemberCount,
    uint taskDateCreated,
    uint taskMilestoneDate,
    uint taskStatus
    ) {

        var taskStore = DataStore(taskStoreAddress);
        if (taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }
        //Client/Front-end should get the title and description as getStringValue
        //taskTitle = taskStore.getStringValue(keccak256("taskTitle", taskIndex));
        //taskDescription = taskStore.getStringValue(keccak256("taskDescription", taskIndex));
        taskOwner = taskStore.getAddressValue(keccak256("taskOwner", taskIndex));
        taskBudget = taskStore.getIntValue(keccak256("taskBudget", taskIndex));
        taskMemberCount = taskStore.getIntValue(keccak256("taskMemberCount", taskIndex));
        taskDateCreated = taskStore.getIntValue(keccak256("taskDateCreated", taskIndex));
        taskMilestoneDate = taskStore.getIntValue(keccak256("taskMilestoneDate", taskIndex));
        taskStatus = taskStore.getIntValue(keccak256("taskStatus", taskIndex));
    }

//Remove Task
    function archiveTask(address taskStoreAddress, uint taskIndex) public {
        var taskStore = DataStore(taskStoreAddress);

        if (taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setIntValue(keccak256("taskStatus", taskIndex), 3);
    }

//Add members to Project
    function addMemberToTask(address taskStoreAddress, uint name) public pure {

    }

//Remove members from Project
    function removeMemberFromTask(address taskStoreAddress, uint name) public pure {

    }

//Update Task budget
    function updateTaskBudget(address taskStoreAddress, uint taskIndex, uint taskBudget) public {
        var taskStore = DataStore(taskStoreAddress);

        if (taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setIntValue(keccak256("taskBudget", taskIndex), taskBudget);
    }

//Update project title and description
    function updateTaskDetails(address taskStoreAddress, uint taskIndex, string taskTitle, string taskDescription)
    public {
        var taskStore = DataStore(taskStoreAddress);

        if (taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setStringValue(keccak256("taskTitle", taskIndex), taskTitle);
        taskStore.setStringValue(keccak256("taskDescription", taskIndex), taskDescription);
    }
}
