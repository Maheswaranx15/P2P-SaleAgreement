const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
require("@nomiclabs/hardhat-truffle5");


describe("EscrowContract", function () {
  let tokenInstance;
  let escrowContractinstance;

  it("Contract Deployment",async ()=>{

    [owner, buyer, seller, arbitrator] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Token20"); //ERC20 contract
    tokenInstance = await Token.deploy(owner.address);
    await tokenInstance.deployed()

    console.log(tokenInstance.address)

    const EscrowContract = await ethers.getContractFactory("SaleP2P");
    escrowContractinstance = await EscrowContract.deploy();
    await escrowContractinstance.deployed();

    console.log(escrowContractinstance.address)
  })

  it("should create an agreement", async function () {
    await token.connect(owner).transfer(buyer.address, ethers.utils.parseEther("1"));
    var tx = await escrowContract.connect(buyer)
      .createAgreement(
        seller.address,
        arbitrator.address,
        ethers.utils.parseEther("1"),
        token.address
    );
    var txn = await tx.wait();
    const agreementId = txn.events[0].args["agreementId"];
    const agreement = await escrowContract.agreements(agreementId);

    expect(agreement.buyer).to.equal(buyer.address);
    expect(agreement.seller).to.equal(seller.address);
    expect(agreement.arbitrator).to.equal(arbitrator.address);
    expect(agreement.amount).to.equal(ethers.utils.parseEther("1"));
    expect(agreement.state).to.equal(0); 
    expect(agreement.token).to.equal(token.address);
  });

  // it("should pay for an agreement", async function () {
  //   await token
  //     .connect(owner)
  //     .transfer(buyer.address, ethers.utils.parseEther("1"));
  //   var tx = await escrowContract
  //     .connect(buyer)
  //     .createAgreement(
  //       seller.address,
  //       arbitrator.address,
  //       ethers.utils.parseEther("1"),
  //       token.address
  //     );
  //   var txn = await tx.wait();
  //   const agreementId = txn.events[0].args["agreementId"];
  //   await token
  //     .connect(buyer)
  //     .approve(escrowContract.address, ethers.utils.parseEther("1"));
  //   await escrowContract.connect(buyer).pay(agreementId, { value: 0 });
  //   const agreement = await escrowContract.agreements(agreementId);

  //   expect(agreement.state).to; 
  // });

  // it("should deliver an item", async function () {
  //   await token
  //     .connect(owner)
  //     .transfer(buyer.address, ethers.utils.parseEther("1"));
  //   var tx = await escrowContract
  //     .connect(buyer)
  //     .createAgreement(
  //       seller.address,
  //       arbitrator.address,
  //       ethers.utils.parseEther("1"),
  //       token.address
  //     );
  //   var txn = await tx.wait();
  //   const agreementId = txn.events[0].args["agreementId"];
  //   await token
  //     .connect(buyer)
  //     .approve(escrowContract.address, ethers.utils.parseEther("1"));
  //   await escrowContract.connect(buyer).pay(agreementId, { value: 0 });
  //   await escrowContract.connect(seller).deliverItem(agreementId);
  //   const agreement = await escrowContract.agreements(agreementId);

  //   expect(agreement.state).to.equal(2); 
  // });

  // it("should releasePayment for an agreement", async function () {
  //   await token
  //     .connect(owner)
  //     .transfer(buyer.address, ethers.utils.parseEther("1"));
  //   var tx = await escrowContract
  //     .connect(buyer)
  //     .createAgreement(
  //       seller.address,
  //       arbitrator.address,
  //       ethers.utils.parseEther("1"),
  //       token.address
  //     );
  //   var txn = await tx.wait();
  //   const agreementId = txn.events[0].args["agreementId"];
  //   await token
  //     .connect(buyer)
  //     .approve(escrowContract.address, ethers.utils.parseEther("1"));
  //   await escrowContract.connect(buyer).pay(agreementId, { value: 0 });
  //   await escrowContract.connect(seller).deliverItem(agreementId);
  //   await escrowContract.connect(buyer).releasePayment(agreementId);
  //   const agreement = await escrowContract.agreements(agreementId);

  //   expect(agreement.state).to.equal(4); 
  // });

  // it("should resolve a dispute", async function () {
  //   await token
  //     .connect(owner)
  //     .transfer(buyer.address, ethers.utils.parseEther("1"));
  //   var tx = await escrowContract
  //     .connect(buyer)
  //     .createAgreement(
  //       seller.address,
  //       arbitrator.address,
  //       ethers.utils.parseEther("1"),
  //       token.address
  //     );
  //   var txn = await tx.wait();
  //   const agreementId = txn.events[0].args["agreementId"];
  //   await token
  //     .connect(buyer)
  //     .approve(escrowContract.address, ethers.utils.parseEther("1"));
  //   await escrowContract.connect(buyer).pay(agreementId, { value: 0 });
  //   await escrowContract.connect(buyer).raiseDispute(agreementId);
  //   var agreement = await escrowContract.agreements(agreementId);
  //   expect(agreement.state).to.equal(3); 
  //   await escrowContract.connect(arbitrator).resolveDispute(agreementId, true); 
  //   agreement = await escrowContract.agreements(agreementId);
  //   expect(agreement.state).to.equal(4); 
  // });

});
