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

    enum Stage{Init,Reg,Vote,Done}
    Stage public currentStage= Stage.Init;

    address chairPerson;
    mapping(address=>Voter) voter;
    Proposal[] proposal;

    uint startTime;
    modifier ValidStage( Stage reqStage){
        require(currentStage==reqStage);
        _;
    }

    modifier HighestRight(){
        require(msg.sender==chairPerson);
        _;
    }

    event VotingCompleted();

    constructor(uint8 _numProposals) public{
        chairPerson= msg.sender;
        voter[chairPerson].weight=2;
        proposal.length= _numProposals;
        currentStage= Stage.Reg;
        startTime= now;
    }

    function register(address toVoter) public HighestRight() ValidStage(Stage.Reg){
        // require(msg.sender==chairPerson);
        require(voter[toVoter].isVoted==false);
        // if(msg.sender!=chairPerson||voter[toVoter].isVoted) return ;
        voter[toVoter].weight=1;
        voter[toVoter].isVoted=false;
    }

    function ChangeStage(Stage _stage) public{
        currentStage= _stage;
    }

    function vote(uint8 toProposal) public ValidStage(Stage.Vote){
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


    function winningProposal() public ValidStage(Stage.Done) view returns (uint8 _winningProposal){
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