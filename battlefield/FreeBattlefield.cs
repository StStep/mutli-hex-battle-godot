using Godot;
using System;
using System.Collections.Generic;

public class FreeBattlefield : Node
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    private PackedScene _freeUnit = GD.Load<PackedScene>("res://battlefield/freeunit/FreeUnit.tscn"); // Will load when the script is instanced.

    private List<FreeUnit> _units = new List<FreeUnit>();

    public IEnumerable<FreeUnit> Units => _units;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {

    }

    public void CreateUnit(String type)
    {
        var u = _freeUnit.Instance() as FreeUnit;
        GetNode("Units").AddChild(u);
        u.CanDrag = true;
        u.Dragging = true;
        u.Connect("Picked", this, "PickedUnit");
        u.Connect("Placed", this, "PlacedUnit");
        _units.Add(u);
    }

    private void PickedUnit(FreeUnit unit)
    {
        _units.ForEach(u => u.CanDrag = false);
        unit.CanDrag = true;
    }

    private void PlacedUnit(FreeUnit unit)
    {
        _units.ForEach(u => u.CanDrag = true);
    }
}
