
using Godot;
using System;

public class FreeUnit : Node
{
    public enum State { Placing, Moving };

    private Node _dragable;
    private Node _follow;
    private Polygon2D _primary;
    private Polygon2D _preview1;
    private Node _follow1;
    private Polygon2D _preview2;
    private Node _follow2;
    private Polygon2D _preview3;

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
                    _preview1.Hide();
                    _preview2.Hide();
                    _preview3.Hide();
                    _follow.Set("enabled", false);
                    _follow1.Set("enabled", false);
                    _follow2.Set("enabled", false);
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
                    _follow.Set("enabled", true);
                    break;
                default:
                    break;
            }
        }
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _primary = GetNode<Polygon2D>("Primary");
        _dragable = _primary.GetNode("Dragable");
	    _dragable.Connect("drag_started", this, "Pickup");
	    _dragable.Connect("drag_ended", this, "Place");
	    _dragable.Connect("point_to", this, "PointTo");
	    _dragable.Connect("drag_to", this, "MoveTo");
        _follow = _primary.GetNode("FollowOnClickable");
        _follow.Set("enabled", false);
	    _follow.Connect("updated", this, "MovePreview1To");
	    _follow.Connect("started", this, "StartMoving");
	    _follow.Connect("ended", this, "EndMoving");

        _preview1 = _primary.GetNode<Polygon2D>("Preview1");
        _follow1 = _preview1.GetNode("FollowOnClickable");
        _follow1.Set("enabled", false);
	    _follow1.Connect("updated", this, "MovePreview2To");
	    _follow1.Connect("started", this, "StartMoving");
	    _follow1.Connect("ended", this, "EndMoving");

        _preview2 = _preview1.GetNode<Polygon2D>("Preview2");
        _follow2 = _preview2.GetNode("FollowOnClickable");
        _follow2.Set("enabled", false);
	    _follow2.Connect("updated", this, "MovePreview3To");
	    _follow2.Connect("started", this, "StartMoving");
	    _follow2.Connect("ended", this, "EndMoving");

        _preview3 = _preview2.GetNode<Polygon2D>("Preview3");
    }

    private void Pickup(Node dragable) => EmitSignal(nameof(Picked), this);
    private void Place(Node dragable) => EmitSignal(nameof(Placed), this);

    private void PointTo(float rads) => _primary.GlobalRotation = rads;
    private void MoveTo(Vector2 loc) => _primary.GlobalPosition = loc;

    private void StartMoving(Node follow)
    {
        _follow.Set("enabled", false);
        _follow1.Set("enabled", false);
        _follow2.Set("enabled", false);
        follow.Set("enabled", true);

        if (follow == _follow)
        {
            _preview1.Show();
            _preview1.GlobalPosition = _primary.GlobalPosition;
            _preview1.GlobalRotation = _primary.GlobalRotation;
        }
        else if (follow == _follow1)
        {
            _preview2.Show();
            _preview2.GlobalPosition = _preview1.GlobalPosition;
            _preview2.GlobalRotation = _preview1.GlobalRotation;
        }
        else if (follow == _follow2)
        {
            _preview3.Show();
            _preview3.GlobalPosition = _preview2.GlobalPosition;
            _preview3.GlobalRotation = _preview2.GlobalRotation;
        }
        else
        {
        }
    }

    private void EndMoving(Node follow)
    {
        if (_preview1.Visible) _follow.Set("enabled", true);
        if (_preview2.Visible) _follow1.Set("enabled", true);
        if (_preview3.Visible) _follow2.Set("enabled", true);

        if (follow == _follow)
        {
            _follow1.Set("enabled", true);
        }
        else if (follow == _follow1)
        {
            _follow2.Set("enabled", true);
        }
        else
        {
        }
    }

    private void MovePreview1To(Vector2 loc) => _preview1.GlobalPosition = loc;

    private void MovePreview2To(Vector2 loc) => _preview2.GlobalPosition = loc;

    private void MovePreview3To(Vector2 loc) => _preview3.GlobalPosition = loc;
}
