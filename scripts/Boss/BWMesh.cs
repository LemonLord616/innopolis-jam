using System;
using System.Diagnostics;
using Godot;

public partial class BWMesh : Node
{
    public event Action OnHitEv;

    [Export] public AnimationPlayer AnimationPlayer { get; private set; }
    [Export] public Area3D HitArea { get; private set; }

    private Node3D _player;

    public override void _Ready()
    {
        base._Ready();
        HitArea.BodyEntered += OnBodyEntered;
        HitArea.BodyExited += OnBodyExited;
    }

    public override void _ExitTree()
    {
        base._ExitTree();
        HitArea.BodyEntered -= OnBodyEntered;
        HitArea.BodyExited -= OnBodyExited;  
    }

    public void UseMeleeAttack()
    {
        GD.Print($"USeHit, {_player == null}");
        if (_player != null){
            GD.Print("Hit");
            OnHitEv?.Invoke();
        }
    }
    
    private void OnBodyEntered(Node3D body)
    {
        var sc = body.GetScript().As<Script>();
        if (sc != null && sc.GetGlobalName().ToString().GetHashCode() == "Player".GetHashCode())
            _player = body;
    }

    private void OnBodyExited(Node3D body)
    {
        var sc = body.GetScript().As<Script>();

        if (sc != null && sc.GetGlobalName().ToString().GetHashCode() == "Player".GetHashCode())
            _player = null;
    }
}