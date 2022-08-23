const {assert} = require('chai');

const KryptoBirdz = artifacts.require("KryptoBirdz");

//check for chai
require('chai').use(require('chai-as-promised')).should();

contract('KryptoBirdz', (accounts) => {
    let contract;
    
    let mint1 = 'https...1';
    let mint2 = 'https...2';
    let mint3 = 'https...3';
    let mint4 = 'https...4';

    before( async () => {
        contract = await KryptoBirdz.deployed();
    })
    
    //testing contrainer - describe
    describe('Deployment', async() => {
        //test samples with writing it
        it('deployed sucesfully', async()=>{
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })

        it('name match', async()=>{
            let name = await contract.name();
            assert.equal(name,'KryptoBird');
        })

        it('symbol match', async()=>{
            let symbol = await contract.symbol();
            assert.equal(symbol,'KBIRDZ');
        })
    })

    describe('minting', async()=> {
        it('create a new token', async()=>{
            const result =  await contract.mint(mint1);
            const totalSupply = await contract.totalSupply();

            //success
            assert.equal(totalSupply, 1);
            const event =  result.logs[0].args;
            assert.equal('0x0000000000000000000000000000000000000000', event._from, 'from is the contract');
            assert.equal(accounts[0], event._to, 'to is msg.sender');

            //failure
            await contract.mint(mint1).should.be.rejected;
        })
    });

    describe('indexing', async()=>{
        it('list KryptoBirdz', async()=>{
            await contract.mint(mint2);
            await contract.mint(mint3);
            await contract.mint(mint4);

            const totalSupply = await contract.totalSupply();
            //success
            assert.equal(totalSupply, 4);

            let result = [];
            let kryptoBird;
            for(i=0; i < totalSupply; i++) {
                kryptoBird = await contract.kryptoBirds(i);
                result.push(kryptoBird);
            }
            let expected = [mint1, mint2, mint3, mint4]
            assert.equal(totalSupply, result.length);
            assert.equal(result.join(','), expected.join(','));
            //assert.equal(result, expected);
        })
    })
})