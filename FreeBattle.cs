using Godot;
using System;
using System.Collections.Generic;

public class FreeBattle: Node
{
    public enum BattleState { None, Deploying, Moving };

    private BattleState _state;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
	    GetNode("DeployGui").Set("create_unit", GD.FuncRef(GetNode("Battlefield"), "CreateUnit"));
	    GetNode("TurnGui").Connect("finishedDeploying", this, "EndDeployment");

        EnterDeploymentState();
    }

    private void EndDeployment()
    {
        EnterMoveState();
    }

    private void EnterDeploymentState()
    {
        _state = BattleState.Deploying;
	    GetNode("DeployGui").Call("enable");
        foreach (var u in (GetNode("Battlefield") as FreeBattlefield).Units)
        {
            u.CurState = FreeUnit.State.Placing;
        }
    }

    private void EnterMoveState()
    {
        _state = BattleState.Moving;
	    GetNode("DeployGui").Call("disable");
        foreach (var u in (GetNode("Battlefield") as FreeBattlefield).Units)
        {
            u.CurState = FreeUnit.State.Moving;
        }
    }
}
