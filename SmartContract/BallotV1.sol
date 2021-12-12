pragma solidity ^0.5.1;

contract Ballot{
    struct Voter{
        uint weight;
        bool isVoted;
        uint vote;
    }
    struct Proposal{
        uint voteCount;
    }

    address chairPerson;
    mapping(address=>Voter) voter;
    Proposal[] proposal;

    constructor(uint8 _numProposals) public{
        chairPerson= msg.sender;
        voter[chairPerson].weight=2;
        proposal.length= _numProposals;
    }

    function register(address toVoter) public{
        require(msg.sender==chairPerson);
        require(voter[toVoter].isVoted==false);
        // if(msg.sender!=chairPerson||voter[toVoter].isVoted) return ;
        voter[toVoter].weight=1;
        voter[toVoter].isVoted=false;
    }

    function vote(uint8 toProposal) public{
        Voter storage sender= voter[msg.sender];
        require(sender.isVoted==false);
        require(toProposal<proposal.length);
        // if(sender.isVoted||toProposal>=proposal.length) return;
        sender.isVoted= true;
        sender.vote= toProposal;
        proposal[toProposal].voteCount+= sender.weight;
    }

    // function CurrentVote(uint8 prop) public view returns(uint256 numVote){
    //     numVote= proposal[prop].voteCount;
    // }

    function CurrentVote(uint8 prop) public view returns(uint256 numVote) {
        numVote= proposal[prop].voteCount;
    }


    function winningProposal() public view returns (uint8 _winningProposal){
        uint256 winningVoteCount = 0;
        
        for(uint8 prop=0;prop<proposal.length;prop++){
            if(proposal[prop].voteCount>winningVoteCount){
                winningVoteCount=proposal[prop].voteCount;
                _winningProposal= prop;
            }else if(proposal[prop].voteCount==winningVoteCount){
                if(voter[chairPerson].vote==prop){
                    winningVoteCount=proposal[prop].voteCount;
                    _winningProposal= prop;
                }
            }
        }
    }



}