pragma solidity ^0.4.0;

import "./DataStore.sol";


library TasksLibrary {
    
    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    function taskCount(address taskStoreAddress) constant returns (uint count) {
        return DataStore(taskStoreAddress).count();
    }

    function createTask (address taskStoreAddress, string title, string description, string tags, uint budget) {
        var taskStore = DataStore(taskStoreAddress);
        taskStore.increaseCount();
        var taskIndex = taskStore.count();

        taskStore.setIntValue(sha3('taskID', taskIndex), taskIndex);
        taskStore.setStringValue(sha3('taskTitle', taskIndex), title);
        taskStore.setStringValue(sha3('taskDescription', taskIndex), description);
        taskStore.setAddressValue(sha3('taskOwner', taskIndex),msg.sender);
        taskStore.setStringValue(sha3('tags', taskIndex), tags);
        taskStore.setIntValue(sha3('taskBudget', taskIndex), budget);
        taskStore.setIntValue(sha3('taskDateCreated', taskIndex), now);
        taskStore.setIntValue(sha3('taskStatus', taskIndex), 0);
    }

    function getTask(address taskStoreAddress, uint taskIndex) constant returns (address taskOwner, uint taskBudget,
                        uint taskMemberCount, uint taskDateCreated, uint taskMilestoneDate, uint taskStatus) {

        var taskStore = DataStore(taskStoreAddress);
        if (taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }
        //Client/Front-end should get the title and description as getStringValue
        //taskTitle = taskStore.getStringValue(sha3('taskTitle', taskIndex));
        //taskDescription = taskStore.getStringValue(sha3('taskDescription', taskIndex));
        taskOwner = taskStore.getAddressValue(sha3('taskOwner', taskIndex));
        taskBudget = taskStore.getIntValue(sha3('taskBudget', taskIndex));
        taskMemberCount = taskStore.getIntValue(sha3('taskMemberCount', taskIndex));
        taskDateCreated = taskStore.getIntValue(sha3('taskDateCreated', taskIndex));
        taskMilestoneDate = taskStore.getIntValue(sha3('taskMilestoneDate', taskIndex));
        taskStatus = taskStore.getIntValue(sha3('taskStatus', taskIndex));
    }

//Remove Task
    function archiveTask(address taskStoreAddress, uint taskIndex) {
        var taskStore = DataStore(taskStoreAddress);

        if(taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setIntValue(sha3('taskStatus', taskIndex), 3);
    }

//Add members to Project
    function addMemberToTask(address taskStoreAddress, uint name) {
        
    }

//Remove members from Project
    function removeMemberFromTask(address taskStoreAddress, uint name) {
        
    }

//Update Task budget
    function updateTaskBudget(address taskStoreAddress, uint taskIndex, uint taskBudget) {
        var taskStore = DataStore(taskStoreAddress);

        if(taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setIntValue(sha3('taskBudget', taskIndex), taskBudget);
    }

//Update project title and description
    function updateTaskDetails(address taskStoreAddress, uint taskIndex, string taskTitle, string taskDescription) {
        var taskStore = DataStore(taskStoreAddress);

        if(taskIndex < 1 || taskIndex > taskStore.count()) {
            return;
        }

        taskStore.setStringValue(sha3('taskTitle', taskIndex), taskTitle);
        taskStore.setStringValue(sha3('taskDescription', taskIndex), taskDescription);
    }
}