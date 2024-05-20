// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 collected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public NoOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadeline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage newCampaign = campaigns[NoOfCampaigns];

        require(
            newCampaign.deadline < block.timestamp,
            "Deadline should be in future"
        );

        newCampaign.owner = _owner;
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.target = _target;
        newCampaign.deadline = _deadeline;
        newCampaign.image = _image;
        newCampaign.collected = 0;

        NoOfCampaigns++;
        return NoOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage selectedCampaign = campaigns[_id];

        require(
            selectedCampaign.deadline > block.timestamp,
            "Campaign is expired"
        );

        selectedCampaign.donators.push(msg.sender);
        selectedCampaign.donations.push(amount);

        (bool sent, ) = selectedCampaign.owner.call{value: amount}("");

        if (sent) {
            selectedCampaign.collected += amount;
        }
    }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](NoOfCampaigns);

        for (uint256 i = 0; i < NoOfCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }
        return allCampaigns;
    }
}
