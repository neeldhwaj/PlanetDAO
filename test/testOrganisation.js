'use strict';

const Organisation = artifacts.require('../contracts/Organisation.sol');

contract('Organisation', function(accounts) {
    let organisation;

    beforeEach(async function() {
        organisation = await Organisation.new();
    });

    describe('createColony', function() {
        it('should add a colony', async function() {
            let colonyCount = await organisation.numColonies();
            assert.equal(colonyCount.valueOf(), 0);
            await organisation.createColony("test", "desc", 1000);
            colonyCount = await organisation.numColonies();
            assert.equal(colonyCount.valueOf(), 1);    
        });
    });

    describe('createProject', function() {
        it('should ass a Project', async function() {
            let projectCount = await organisation.numProjects()
            assert.equal(projectCount.valueOf(), 0);
            await organisation.createProject("Test", "desc", 1000);
            projectCount = await organisation.numProjects();
            assert.equal(projectCount.valueOf(), 1);
        });
    });
    
    describe('createTask', function() {
        it('should add a task', async function() {
            let taskCount = await organisation.numTasks();
            assert.equal(taskCount.valueOf(), 0);
            await organisation.createTask("Test", "desc", "x;y;z", 1000);
            taskCount = await organisation.numTasks();
            assert.equal(taskCount.valueOf(), 1);
        });
    });
});