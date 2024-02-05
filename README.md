# P2P-SaleAgreement
Write a smart contract that supports agreements between two users to sell a tangible item in exchange for ETH or any ERC-20 token. In case of disputes, the role of an arbitrator to resolve the dispute is to be included

# To start
-> git clone https://github.com/Maheswaranx15/P2P-SaleAgreement.git
-> To install packages : npm install 
-> Add .env and its variables located as per in .env.sample

# Functionalities 
-> **Establishing an Agreement**: Initiate a new agreement by utilizing the createAgreement function, specifying the seller, arbitrator, payment amount, and token.
-> **Making a Payment**: Buyers can conveniently make payments using the pay function, accommodating both Ether and ERC-20 token payments.
-> **Confirming Item Delivery** : Sellers can mark the item as delivered using the deliverItem function, ensuring a seamless transaction process.
-> **Initiating a Dispute**: Either party can raise a dispute using the raiseDispute function, guaranteeing a fair resolution in case of any disagreements.
-> **Resolving Disputes** : The arbitrator, empowered to resolve disputes, can utilize the resolveDispute function, ensuring fairness and transparency throughout the process.
-> **Releasing Payment**: Sellers have the authority to release payments using the releasePayment function after successfully delivering the item, fostering trust and reliability.

# To Complile : 
-> npx hardhat compile

# To run Test scripts :  
-> npx hardhat test

# To Deploy :
-> npx hardhat deploy ./scripts/deploy.js --network network name