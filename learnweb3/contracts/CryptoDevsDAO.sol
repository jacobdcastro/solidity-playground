// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function purchase(uint256 _tokenId) external payable;

    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);
}

interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);
}

contract CryptoDevsDAO is Ownable {
    struct Proposal {
        // nftTokenId - the tokenID of the NFT to purchase from FakeNFTMarketplace if the proposal passes
        uint256 nftTokenId;
        // deadline - the UNIX timestamp until which this proposal is active. Proposal can be executed after the deadline has been exceeded.
        uint256 deadline;
        // yayVotes - number of yay votes for this proposal
        uint256 yayVotes;
        // nayVotes - number of nay votes for this proposal
        uint256 nayVotes;
        // executed - whether or not this proposal has been executed yet. Cannot be executed before the deadline has been exceeded.
        bool executed;
        // voters - a mapping of CryptoDevsNFT tokenIDs to booleans indicating whether that NFT has already been used to cast a vote or not
        mapping(uint256 => bool) voters;
    }

    enum Vote {
        YAY, // YAY = 0
        NAY // NAY = 1
    }

    mapping(uint256 => Proposal) public proposals;
    // Number of proposals that have been created
    uint256 public numProposals;

    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevsNFT cryptoDevsNFT;

    constructor(address _nftMarketplace, address _cryptoDevsNFT) payable {
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
    }

    modifier nftHolderOnly() {
        require(
            cryptoDevsNFT.balanceOf(msg.sender) > 0,
            "Must be a DAO member!"
        );
        _;
    }

    modifier activeProposalOnly(uint256 proposalIndex) {
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "Deadline exceeded!"
        );
        _;
    }

    modifier inactiveProposalOnly(uint256 proposalIndex) {
        require(
            proposals[proposalIndex].deadline <= block.timestamp,
            "Deadline NOT exceeded!"
        );
        require(
            proposals[proposalIndex].executed == false,
            "Proposal already executed!"
        );
        _;
    }

    /// @dev createProposal allows a CryptoDevsNFT holder to create a new proposal in the DAO
    /// @param _nftTokenId - the tokenID of the NFT to be purchased from FakeNFTMarketplace if this proposal passes
    /// @return Returns the proposal index for the newly created proposal
    function createProposal(uint256 _nftTokenId)
        external
        nftHolderOnly
        returns (uint256)
    {
        require(
            nftMarketplace.available(_nftTokenId),
            "NFT is not available for purchase"
        );
        Proposal storage proposal = proposals[numProposals];
        proposal.nftTokenId = _nftTokenId;
        // Set the proposal's voting deadline to be (current time + 5 minutes)
        proposal.deadline = block.timestamp + 5 minutes;

        numProposals++;

        return numProposals - 1;
    }

    /// @dev voteOnProposal allows a CryptoDevsNFT holder to cast their vote on an active proposal
    /// @param proposalIndex - the index of the proposal to vote on in the proposals array
    /// @param vote - the type of vote they want to cast
    function voteOnProposal(uint256 proposalIndex, Vote vote)
        external
        nftHolderOnly
        activeProposalOnly(proposalIndex)
    {
        Proposal storage proposal = proposals[proposalIndex];

        uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender);
        uint256 numVotes = 0;

        // Calculate how many NFTs are owned by the voter
        // that haven't already been used for voting on this proposal
        for (uint256 i = 0; i < voterNFTBalance; i++) {
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);
            if (proposal.voters[tokenId] == false) {
                numVotes++;
                proposal.voters[tokenId] = true;
            }
        }
        require(numVotes > 0, "Already voted!");

        if (vote == Vote.YAY) {
            proposal.yayVotes += numVotes;
        } else {
            proposal.nayVotes += numVotes;
        }
    }

    function executeProposal(uint256 proposalIndex)
        external
        nftHolderOnly
        inactiveProposalOnly(proposalIndex)
    {
        Proposal storage proposal = proposals[proposalIndex];

        // If the proposal has more YAY votes than NAY votes
        // purchase the NFT from the FakeNFTMarketplace
        if (proposal.yayVotes > proposal.nayVotes) {
            uint256 nftPrice = nftMarketplace.getPrice();
            require(
                address(this).balance >= nftPrice,
                "Insufficient Funds, cannot purchawse NFT"
            );
            nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }
        proposal.executed = true;
    }

    /// @dev withdrawEther allows the contract owner (deployer) to withdraw the ETH from the contract
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}
