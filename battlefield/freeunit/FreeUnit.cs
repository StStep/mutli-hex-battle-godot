
using Godot;
using System;

public class FreeUnit : Node2D
{
    public enum State { Placing, Moving };

    private Node _dragable;

    [Signal]
    delegate void Picked(FreeUnit u);

    [Signal]
    delegate void Placed(FreeUnit u);

    public Boolean CanDrag
    {
        get => (Boolean)_dragable.Get("can_drag");
        set => _dragable.Set("can_drag", value);
    }

    public Boolean Dragging
    {
        get => (Boolean)_dragable.Get("dragging");
        set => _dragable.Set("dragging", value);
    }

    private State __curstate;
    public State CurState
    {
        get => __curstate;
        set
        {

            if (__curstate == value)
                return;

            // Prev State
            switch(__curstate)
            {
                case FreeUnit.State.Placing:
                    CanDrag = false;
                    break;
                case FreeUnit.State.Moving:
                    break;
                default:
                    break;
            }

	        // Future State
            switch(value)
            {
                case FreeUnit.State.Placing:
                    CanDrag = true;
                    break;
                case FreeUnit.State.Moving:
                    break;
                default:
                    break;
            }
        }
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _dragable = GetNode("Dragable");
	    _dragable.Connect("drag_started", this, "Pickup");
	    _dragable.Connect("drag_ended", this, "Place");
	    _dragable.Connect("point_to", this, "PointTo");
	    _dragable.Connect("drag_to", this, "MoveTo");
    }

    private void Pickup(Node dragable) => EmitSignal(nameof(Picked), this);
    private void Place(Node dragable) => EmitSignal(nameof(Placed), this);

    private void PointTo(float rads) => Rotation = rads;
    private void MoveTo(Vector2 loc) => GlobalPosition = loc;
}
