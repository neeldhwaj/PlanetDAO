'use strict';

const DataStore = artifacts.require('../contracts/DataStore.sol');
const Organisation = artifacts.require('../contracts/Organisation.sol');
const sha3 = require('solidity-sha3').default;

import expectThrow from './helpers/expectThrow';

contract('Organisation', function(accounts) {
    let memberStore, projectStore, taskStore, org;

    beforeEach(async function() {
        memberStore = await DataStore.new();
        projectStore = await DataStore.new();
        taskStore = await DataStore.new();
        org = await Organisation.new({value: web3.toWei(0.1)});
        // Transfer ownership of stores from default account to organisation. This allows modifying the data store.
        memberStore.transferOwnership(org.address);
        projectStore.transferOwnership(org.address);
        taskStore.transferOwnership(org.address);
        await org.setDataStore(memberStore.address, projectStore.address, taskStore.address);
        // await org.setDataStore(0x0, 0x0);
        // TODO Investigate why org works with 0x0 data stores too.
    });

    describe('addMember', function() {
        it.skip('should add the member', async function() {
            await org.addMember(accounts[0], 1);
            let count = await org.memberCount();
            assert.equal(count.valueOf(), 1);
            let member = await org.getMember(1);
            let attr = member.split(';');
            assert.equal(attr[0], '1');    
            assert.equal('0x' + attr[1], accounts[0]);
            assert.equal(attr[2], '0');
            assert.isAtMost(attr[3], Math.floor(Date.now() / 1000));
            assert.isAbove(attr[3], Math.floor(Date.now() / 1000) - 300);       
        });
    });

    describe('removeMember', function() {
        it.skip('should deactivate the member', async function() {
            await org.addMember(accounts[0], 1);
            await org.removeMember(accounts[0]);
            let count = await org.memberCount();
            assert.equal(count.valueOf(), 0);
            let member = await org.getMember(1);
            let attr = member.split(';');
            assert.equal(attr[0], '1');
            assert.equal('0x' + attr[1], accounts[0]);
            assert.equal(attr[2], '1');
            assert.isAtMost(attr[3], Math.floor(Date.now() / 1000));
            assert.isAbove(attr[3], Math.floor(Date.now() / 1000) - 300);
        });
    });

    describe('getAllMembers', function() {
        it.skip('should provide details of all members', async function() {
            let info = [
                {index: 1},
                {index: 2},
                {index: 3},
            ];
            for (let i=0; i<3; i++) {
                await org.addMember(accounts[i], info[i].index);
            }
            let [members, count] = await org.getAllMembers();
            assert.equal(count, 3);     // Including the default member
            members = members.split('|');
            for (let i=0; i<3; i++) {
                 let attr = members[i].split(';');
                 assert.equal(attr[0], i+1);     // ID starts from 1, not 0.
                 assert.equal('0x' + attr[1], accounts[i]);
                 assert.equal(attr[2], '0');
                 assert.isAtMost(attr[3], Math.floor(Date.now() / 1000));
                 assert.isAbove(attr[3], Math.floor(Date.now() / 1000) - 300);

                 let index = await memberStore.getAddressIndex(sha3('accountIndex'), accounts[i]);
                 assert.equal(index, info[i].index);
            }
        });
    });
});