pragma solidity ^0.4.2;

import "./helper_contracts/strings.sol";
import "./helper_contracts/StringLib.sol";
import "./helper_contracts/zeppelin/lifecycle/Killable.sol";

contract Organisation is Killable {
    
    enum MemberRole {
    Owner,
    Admin,
    Member
    }

    enum TaskStage {
        ToDo,
        InProgress,
        Completed
    }

    struct Colony {
        string colonyName;
        string colonyDescription;
        address colonyOwner;
        mapping (uint => Project) projects;
        mapping (uint => Member) colonyMembers;
        uint totalBudget;
        uint currentAssignedBudget;
        uint colonyMemberCount;
    } 

    struct Project {
        string projectTitle;
        string projectDescription;
        address projectOwner;
        mapping (uint => Member) projectMembers;
        mapping (uint => Task) tasks;
        uint projectMemberCount;
        uint dateCreated;
        uint projectMilestoneDate;
    }

    struct Task {
        string taskTitle;
        string taskDescription;
        address taskOwner;
        string tags; // use comma separated tags to store instead of string dynamic arrays restriction is Solidity
        uint dateCreated;
        uint budgetAllocated;
        mapping (uint => Member) membersAssigned;
        uint taskMilestoneDate;
        TaskStage taskStage;
    }

    struct Member {
        string memberName;
        address memberAccount;
        string memberEmail;
        MemberRole memberRole;
        uint dateAdded;
    }

    uint public numColonies;
    uint public numProjects;
    uint public numTasks;
    uint public numMembers;

    mapping (uint => Colony) colonies;                 // index 0 to be kept free since 0 is default value
    mapping (uint => Member) members;               // index 0 to be kept free since 0 is default value
    mapping (address => uint) memberIndex;
    mapping (string => uint) emailIndex;

}