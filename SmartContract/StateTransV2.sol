pragma solidity ^0.5.1;

contract StatTranV2{
    enum Stage {Init,Reg,Vote,Done}
    Stage public stage;
    uint startTime;
    uint public timeNow;

    constructor() public{
        stage= Stage.Init;
        startTime= now;
    }

    function AdvanceState() public{
        timeNow= now;
        if(timeNow >(startTime+ 1 minutes)){
            startTime= timeNow;
            if(stage== Stage.Init){
                stage= Stage.Reg;
                return;
            }
            if(stage== Stage.Reg){
                stage= Stage.Vote;
                return;
            }
            if(stage== Stage.Vote){
                stage= Stage.Done;
                return;
            }
            return;
        }
        
    }



}