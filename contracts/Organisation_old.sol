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

    enum MemberCategory {
        Project,
        Task
    }

    enum TaskStage {
        ToDo,
        InProgress,
        Completed
    }

    struct Colony {
        uint colonyID;
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
        uint projectID;
        string projectTitle;
        string projectDescription;
        address projectOwner;
        mapping (uint => Member) projectMembers;
        mapping (uint => Task) tasks;
        uint projectBudget;
        uint projectMemberCount;
        uint dateCreated;
        uint projectMilestoneDate;
    }

    struct Task {
        uint taskID;
        string taskTitle;
        string taskDescription;
        address taskOwner;
        string tags; // use semi-colon separated tags to store instead of string dynamic arrays restriction is Solidity
        uint dateCreated;
        uint budgetAllocated;
        mapping (uint => Member) taskMembers;
        uint taskMemberCount;
        uint taskMilestoneDate;
        TaskStage taskStage;
    }

    struct Member {
        string memberName;
        address memberAccount;
        string memberEmail;
        string memberSkillSet; // use semi-colon separated skill set
        MemberRole memberRole;
        uint dateAdded;
    }

    uint public numColonies;
    uint public numProjects;
    uint public numTasks;
    uint public numTotalMembers;

    mapping (uint => Colony) colonies;                 // index 0 to be kept free since 0 is default value
    mapping (uint => Member) members;               // index 0 to be kept free since 0 is default value
    mapping (uint => Project) projects;
    mapping (uint => Task) tasks;
    mapping (address => uint) memberIndex;
    mapping (string => uint) memberEmailIndex;
    mapping (string => uint) colonyIndex; //colonyname => colonyID mapping
    mapping (string => uint) projectIndex; //Project title => Project ID
    mapping (string => uint) taskIndex;

    function createColony(string colonyName, string colonyDescription, uint colonyBudget) {
        colonies[++numColonies] = Colony(numColonies, colonyName, colonyDescription, msg.sender, colonyBudget, 0, 0);
        colonyIndex[colonyName] = numColonies;

    }

    function createMember (string name, address account, string email, string skillSet, MemberRole memberRole) {
        members[++numTotalMembers] = Member(name, account, email, skillSet, memberRole, now);
        memberIndex[account] = numTotalMembers;
        memberEmailIndex[email] = numTotalMembers;
    }

    function createProject (string title, string description, uint budget) {
        projects[++numProjects] = Project(numProjects, title, description, msg.sender, budget, 0, now, 0);
        projectIndex[title] = numProjects;
    }

    function createTask (string title, string description, string tags, uint budget) {
        tasks[++numTasks] = Task(numTasks, title, description, msg.sender, tags, now, budget, 0, 0, TaskStage.ToDo);
        taskIndex[title] = numTasks;
    }

    function assignMembersToProjectOrTask(MemberCategory key, uint ID, address memberAccount) {
        var index = memberIndex[memberAccount];
        uint memberCount = 0;
        if (key == MemberCategory.Project) {
            memberCount = projects[ID].projectMemberCount++;
            projects[ID].projectMembers[++memberCount] = members[index];
        }

        else if (key == MemberCategory.Task) {
            memberCount = tasks[ID].taskMemberCount++ ;
            tasks[ID].taskMembers[++memberCount] = members[index];
        }
    }

}